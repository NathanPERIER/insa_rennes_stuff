/*
 * fault_handler.c
 *
 *  Created on: 1 nov. 2008
 *      Author: lescouarnecn
 */
#include "mmu.h"
#include "physical_memory.h"
#include "swap.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <assert.h>
#include <time.h>

// Page fault handler
//     Free one page if needed
//     Get free page
//     Load
//     Update MMU

enum state_page {SWAPPED, ALLOCATED, NOTMAPPED};

#define PRECLEAN

struct page_table_entry{
	enum state_page status;
	page_phys pp;
};

// Page table
struct page_table_entry* page_table;
int page_table_size;

// List of allocated pages
page_virt* allocated_pages;
int allocated_pages_capacity;
int allocated_pages_size;
int allocated_pages_first;




void init_faultHandler(int nb_pages_virt, int nb_pages_phys){
	int i;
	page_table=(struct page_table_entry*)malloc(sizeof(struct page_table_entry)*nb_pages_virt);
	page_table_size=nb_pages_virt;
	for(i=0;i<nb_pages_virt;i++){
		page_table[i].pp=INVALID;
		page_table[i].status=NOTMAPPED;
	}

	allocated_pages=(page_virt*)malloc(sizeof(page_virt)*nb_pages_phys);
	allocated_pages_capacity=nb_pages_phys;
	for(i=0;i<nb_pages_phys;i++){
		allocated_pages[i]=INVALID;
	}

}

void unloadAPage();
void loadAPage(page_virt pv);

void page_fault_handler(page_virt pv){
	
	// Get a Free block
	if(pm_isFull()){
		printf("PF: Unload a page\n");
		unloadAPage();
	}
	page_phys pp = pm_getFreePage();

	// Mark page as loaded
	printf("PF: Load a page (%d)\n",pv);
	loadAPage(pv);

	// Read from Swap
	if(page_table[pv].status == SWAPPED){
		swap_read(pv,pp);
	}

	// Update page table
	page_table[pv].pp=pp;
	page_table[pv].status=ALLOCATED;

	// Write to MMU
	mmu_addTranslation(pv,pp);

	// That's all
}

#ifdef POLICY_FIFO
int i = 0;

void unloadAPage(){
	page_virt v = allocated_pages[i];
    struct page_table_entry* entry = page_table + v;
    page_phys p = entry->pp;
    if(mmu_isDirty(v)) {
        allocate_swap(v);
        swap_write(v, p);
        mmu_clearDirtyBit(v);
    }
    entry->status = SWAPPED;
    pm_freePage(p);
    allocated_pages[i] = INVALID;
    mmu_invalidatePage(v);
}

void loadAPage(page_virt pv) {
	if(allocated_pages[i] != INVALID) {
		printf("This shouldn't happen\n");
	}
	allocated_pages[i] = pv;
	i = (i+1) % allocated_pages_capacity;
}
#endif

#ifdef POLICY_RANDOM
void unloadAPage(){
	unsigned int i = time(NULL) % allocated_pages_capacity;
	//printf("%d %d\n", i, allocated_pages_capacity);
	page_virt v = allocated_pages[i];
	struct page_table_entry* entry = page_table + v;
	//printf("%d %d\n", v, page_table_size);
	page_phys p = entry->pp;
	if(mmu_isDirty(v)) {
		allocate_swap(v);
		swap_write(v, p);
		mmu_clearDirtyBit(v);
	}
	entry->status = SWAPPED;
	pm_freePage(p);
	allocated_pages[i] = INVALID;
	mmu_invalidatePage(v);
}

void loadAPage(page_virt pv){
	for(int i = 0; i < allocated_pages_capacity; i++) {
		if(allocated_pages[i] == INVALID) {
			allocated_pages[i] = pv;
			return;
		}
	}
}
#endif

#ifdef POLICY_CLOCK
int currentIndex = 0;

void unloadAPage() {
	for(int i=0; i <= allocated_pages_capacity; i++) {
		int index = (currentIndex + i) % allocated_pages_capacity;
		page_virt v = allocated_pages[index];
		if(mmu_isAccessed(v)) {
			mmu_clearAccessedBit(v);
		} else {
			currentIndex = index;
			struct page_table_entry* entry = page_table + v;
			page_phys p = entry->pp;
			if(mmu_isDirty(v)) {
				allocate_swap(v);
				swap_write(v, p);
				mmu_clearDirtyBit(v);
			}
			entry->status = SWAPPED;
			pm_freePage(p);
			allocated_pages[index] = INVALID;
			mmu_invalidatePage(v);
			return;
		}
	}
	printf("Shouldn't be printed\n");
}

void loadAPage(page_virt pv){
	allocated_pages[currentIndex] = pv;
	currentIndex = (currentIndex+1) % allocated_pages_capacity;
	mmu_clearDirtyBit(pv);
	mmu_clearAccessedBit(pv);
}
#endif


