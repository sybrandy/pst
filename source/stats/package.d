module stats;

import std.uni: toLower;
import stats.mean, stats.median, stats.mode, stats.count, stats.sum;

interface Stats(T)
{
    void add(T val);
    void finish();
    string toString();
}

Stats!(T) initStats(T)(string name)
{
    final switch (name.toLower)
    {
        case "count": 
            return new Count!(T)();
        case "sum": 
            return new Sum!(T)();
        case "mean": 
            return new Mean!(T)();
        case "median": 
            return new Median!(T)();
        case "mode": 
            return new Mode!(T)();
    }
    assert(0);
}
