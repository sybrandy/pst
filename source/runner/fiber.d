module runner.fiber;

import std.range.primitives, core.thread, std.functional, std.array, std.stdio;
import stats;

version(unittest)
{
    import unit_threaded;
}

struct FiberRunner(T)
{
    Fiber[] stats;
    bool isDone = false;
    T currValue;
    string[] output;

    void addMetric(string name)
    {
        auto newStat = initStats!(T)(name);
        alias partial!(fiberFunc, newStat) newFunc;
        stats ~= new Fiber(&newFunc);
    }

    void put(T value)
    {
        this.currValue = value;
        foreach (s; this.stats)
        {
            s.call();
        }
    }

    void fiberFunc(Stats!(T) stat)
    {
        while (!isDone)
        {
            stat.add(this.currValue);
            Fiber.yield();
        }
        stat.finish();
        this.output ~= stat.toString();
    }

    void finish()
    {
        this.isDone = true;
        foreach (s; this.stats)
        {
            s.call();
        }
    }

    string getOutput()
    {
        return output.join("\n");
    }
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

@("Test Fiber Mean Only")
unittest
{
    FiberRunner!int fr;

    fr.addMetric("mean");
    fr.put(3);
    fr.put(4);
    fr.put(5);
    fr.finish();
    fr.getOutput.shouldEqual("MEAN: 4");
}
