module runner.fiber;

import std.range.primitives, core.thread, std.functional, std.array, std.stdio;
import stats, runner, common.options;

version(unittest)
{
    import unit_threaded;
}

class FiberRunner(T): Runner!(T)
{
    Fiber[] stats;
    bool isDone = false;
    T currValue;
    string[] output;
    Options currOpts;

    this(Options opts)
    {
        currOpts = opts;
    }

    void addMetric(string name)
    {
        auto newStat = initStats!(T)(name, this.currOpts);
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

version(unittest)
{
    @(1, 2, 5)
    void testAddStat(int numMetrics)
    {
        Options currOpts;
        FiberRunner!int fr = new FiberRunner!int(currOpts);

        for (int i = 0; i < numMetrics; i++)
        {
            fr.addMetric("mean");
        }
        fr.stats.length.shouldEqual(numMetrics);
    }

    @("Test Fiber Mean Only")
    unittest
    {
        Options currOpts;
        FiberRunner!int fr = new FiberRunner!int(currOpts);

        fr.addMetric("mean");
        fr.put(3);
        fr.put(4);
        fr.put(5);
        fr.finish();
        fr.getOutput.shouldEqual("MEAN: 4");
    }
}
