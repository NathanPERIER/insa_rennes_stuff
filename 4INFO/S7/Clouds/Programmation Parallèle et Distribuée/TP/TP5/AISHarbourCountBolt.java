package org.apache.storm.starter.bolt;

import org.apache.storm.starter.spout.RandomAISSpout;
import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

import java.util.HashMap;
import java.util.Map;
import java.util.function.BiFunction;

public class AISHarbourCountBolt extends BaseRichBolt {
    OutputCollector _collector;
    Map<RandomAISSpout.Destination, Integer> cpt;

    @Override
    public void prepare(Map conf, TopologyContext context, OutputCollector collector) {
        _collector = collector;
        cpt = new HashMap<>();
        for(RandomAISSpout.Destination d : RandomAISSpout.Destination.values()) {
            cpt.put(d, 0);
        }
    }

    @Override
    public void execute(Tuple tuple) {
        cpt.compute((RandomAISSpout.Destination)tuple.getValue(2), new BiFunction<RandomAISSpout.Destination, Integer, Integer>() {
            @Override
            public Integer apply(RandomAISSpout.Destination dest, Integer i) {
                return i+1;
            }
        });
        System.out.println(cpt);
        _collector.ack(tuple);
    }

    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields());
    }

}