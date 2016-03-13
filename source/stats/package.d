module stats;

import std.uni;
import stats.mean;

interface Stats(T)
{
    void add(T val);
    T flush();
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
