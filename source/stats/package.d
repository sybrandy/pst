module stats;

import std.uni: toLower;
import stats.mean, stats.median, stats.mode, stats.count, stats.sum,
       stats.stddev, stats.range;
import common.options;

interface Stats(T)
{
    void add(T val);
    void finish();
    string toString();
}

Stats!(T) initStats(T)(string name, Options opts)
{
    final switch (name.toLower)
    {
        case "count": 
            return new Count!(T)(opts);
        case "sum": 
            return new Sum!(T)(opts);
        case "mean": 
            return new Mean!(T)(opts);
        case "median": 
            return new Median!(T)(opts);
        case "mode": 
            return new Mode!(T)(opts);
        case "stddev": 
            return new Stddev!(T)(opts);
        case "range": 
            return new Range!(T)(opts);
    }
    assert(0);
}
