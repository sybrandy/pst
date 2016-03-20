module stats.mode;

import std.array, std.stdio, std.traits, std.conv, std.format, std.algorithm;
import stats;

version(unittest)
{
    import unit_threaded;
}

class Mode(T) : Stats!(T)
{
    T[] vals;
    T result;

    void add(T val)
    {
        this.vals ~= val;
    }

    void finish()
    {
        uint maxCount;
        foreach (v; vals.sort().group)
        {
            if (v[1] > maxCount)
            {
                maxCount = v[1];
                result = v[0];
            }
        }
    }

    override string toString()
    {
        static if (isFloatingPoint!(T))
        {
            return format("MODE: %.4f", result);
        }
        else
        {
            return format("MODE: %d", result);
        }
    }
}

version(unittest)
{
    @Types!(short, int, long, float, double)
    void testAllONes(T)()
    {
        Stats!T mode = initStats!(T)("mode");
        mode.add(1);
        mode.add(1);
        mode.add(1);
        mode.finish();
        static if (isFloatingPoint!(T))
        {
            mode.toString().shouldEqual("MODE: 1.0000");
        }
        else
        {
            mode.toString().shouldEqual("MODE: 1");
        }
    }

    @Types!(short, int, long, float, double)
    void testTwoValues(T)()
    {
        Stats!T mode = initStats!(T)("MODE");
        mode.add(1);
        mode.add(2);
        mode.add(3);
        mode.add(2);
        mode.finish();
        static if (isFloatingPoint!(T))
        {
            mode.toString().shouldEqual("MODE: 2.0000");
        }
        else
        {
            mode.toString().shouldEqual("MODE: 2");
        }
    }
}
