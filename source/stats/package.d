module stats;

import std.uni;
import stats.mean;

interface Stats(T)
{
    void add(T val);
    void finish();
    string toString();
}

Stats!(T) initStats(T)(string name)
{
    name = name.toLower;
    if (name == "mean")
    {
        return new Mean!(T)();
    }
    assert(0);
}
