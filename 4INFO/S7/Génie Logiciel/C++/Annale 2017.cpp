#include <vector>
#include <iostream>

using std::vector;

// Q.2
class Virus {
    private:
        static int NEXT_ID;
        int id;
        bool actif;
    
    protected:
        int col;
        int lig;

    public:
        Virus(int l, int c): lig(l), col(c) {
            id = NEXT_ID++;
            actif = false;
        }

        inline int getId() const { return id; }
        inline int getCol() const { return col; }
        inline int getLine() const { return lig; }

        void setActive(bool a=true) {
            actif = a;
        }

        virtual void deplace(Carte& pl);
};

int Virus::NEXT_ID = 1;

class VirusNiv1: public Virus {
    public:
        VirusNiv1(int l, int c): Virus(l, c) {}

        virtual void deplace(Carte& pl) {
            moveRight(1, pl);
        }
    
    protected:
        void moveRight(const int dist, Carte& c) {
            c.removeVirus(lig, col);
            lig += dist;
            Virus* v = c.getVirus(lig, col);
            if(v != NULL) {
                delete v;
            }
            c.setVirus(this);
            setActive(false);
        }
};

class VirusNiv2: public VirusNiv1 {
    public:
        VirusNiv2(int l, int c): VirusNiv1(l, c) {}

        virtual void deplace(Carte& pl) {
            moveRight(2, pl);
        }
};

// Q.9
class ActionVirus {
    public:
        virtual void operator()(Carte& c, Virus* v);
};

class Depl1Virus2: public ActionVirus {
    public:
        virtual void operator()(Carte& c, Virus* v) {
            if(dynamic_cast<VirusNiv2*>(v)) {
                v->deplace(c);
            }
        }
};

// Q.1
class Carte {
    private:
        int dim;
        vector<vector<Virus*>> mat;

    public:
        Carte(int d): dim(d), mat() {
            for(int i=0; i<dim; i++) {
                mat.push_back(vector<Virus*>(d,NULL));
            }
        }

        inline Virus* getVirus(int l, int c) const { return mat[l][c]; }

        void setVirus(Virus* v) {
            int l = v->getLine();
            int c = v->getCol();
            mat[l][c] = v;
        }

        void removeVirus(int l, int c) {
            mat[l][c] = NULL;
        }

        inline int getDim() const { return dim; }

        // Q.6
        void deplaceTous() {
            Virus* v;
            for(int i=0; i<dim; i++) {
                for(int j=0; j<dim; j++) {
                    v = getVirus(i, j);
                    if(v != NULL) {
                        v->setActive();
                        v->deplace(*this);
                    }
                }
            }
        }

        // Q.7
        // Ajouter une condition dans le `if` qui vérifie qu'on est une instance de `VirusNiv2` 
        // ou d'une sous-classe : `if(v != NULL && dynamic_cast<VirusNiv2*>(v))`

        // Q.8
        // Ajouter une condition dans le `if` qui vérifie qu'on est une instance de `VirusNiv1` ?
        // (je ne sais pas comment cependant)

        // Q.9
        void action(ActionVirus& d) {
            Virus* v;
            for(int i=0; i<dim; i++) {
                for(int j=0; j<dim; j++) {
                    v = getVirus(i, j);
                    if(v != NULL) {
                        d(*this, v);
                    }
                }
            }
        }

        ~Carte() {
            Virus* v;
            for(int i=0; i<dim; i++) {
                for(int j=0; j<dim; j++) {
                    v = getVirus(i, j);
                    if(v != NULL) {
                        delete v;
                    }
                }
            }
        }
};

// Q.3
std::ostream& operator<<(std::ostream& out, const Virus& v) {
    return out << v.getId();
}

// Q.4
std::ostream& operator<<(std::ostream& out, const Carte& c) {
    Virus* v;
    for(int i=0; i<c.getDim(); i++) {
        for(int j=0; j<c.getDim(); j++) {
            v = c.getVirus(i, j);
            if(v != NULL) {
                out << "| " << v->getId() << " ";
            } else {
                out << "| ? ";
            }
        }
        out << "|" << std::endl;
    }
    return out;
}


// Q.5
void test() {
    Carte c(10);
    c.setVirus(new VirusNiv1(0, 0));
    c.setVirus(new VirusNiv2(0, 2));
    c.setVirus(new VirusNiv1(0, 3));
    c.setVirus(new VirusNiv1(1, 0));
    std::cout << c << std::endl;
}