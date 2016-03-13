module runner.fiber;

import std.range.primitives;
import stats;

version(unittest)
{
    import unit_threaded;
}

struct FiberRunner(T)
{
    Stats!T[] stats;
    void addMetric(string name)
    {
        stats ~= initStats!(T)(name);
    }
    /* void put(FiberRunner f, T value) */
    /* { */
    /* } */
}

@(1, 2, 5)
void testAddStat(int numMetrics)
{
    FiberRunner!int fr;

    for (int i = 0; i < numMetrics; i++)
    {
        fr.addMetric("mean");
    }
    fr.stats.length.shouldEqual(numMetrics);
}
