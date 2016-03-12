module stats;

import stats.mean;

interface Stats(T)
{
    void add(T val);
    T flush();
}

Stats!(T) initStats(T)(string name)
{
    if (name == "mean")
    {
        return new Mean!(T)();
    }
    assert(0);
}
