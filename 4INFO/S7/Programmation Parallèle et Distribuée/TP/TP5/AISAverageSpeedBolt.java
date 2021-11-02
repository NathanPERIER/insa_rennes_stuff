package org.apache.storm.starter.bolt;

import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

import java.util.Map;

public class AISAverageSpeedBolt extends BaseRichBolt {
    OutputCollector _collector;
    private double total;
    private int nb;

    @Override
    public void prepare(Map conf, TopologyContext context, OutputCollector collector) {
        _collector = collector;
        total = 0;
        nb = 0;
    }

    @Override
    public void execute(Tuple tuple) {
        nb++;
        total += tuple.getDouble(1);
        System.out.println("Average : " + total/(double)nb);
        _collector.emit(tuple, new Values(total/(double)nb));
        _collector.ack(tuple);
    }

    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields("average"));
    }

}