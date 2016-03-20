module stats;

import std.uni;
import stats.mean, stats.median;

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
        case "mean": 
            return new Mean!(T)();
        case "median": 
            return new Median!(T)();
    }
    assert(0);
}
