module stats.range;

import std.stdio, std.conv, std.format, std.traits, std.math, std.algorithm;
import stats;

version(unittest)
{
    import unit_threaded;
}

class Range(T) : Stats!(T)
{
    bool isSet = false;
    static if (isFloatingPoint!(T))
    {
        double min, max, result;
    }
    else
    {
        static if (isSigned!(T))
        {
            long min, max, result;
        }
        else
        {
            static if (isNumeric!(T))
            {
                ulong min, max, result;
            }
        }
    }

    void add(T val)
    {
        if (!isSet || val < min)
        {
            min = val;
        }
        if (!isSet || val > max)
        {
            max = val;
        }
        isSet = true;
    }

    void finish()
    {
        result = max - min;
    }

    override string toString()
    {
        static if (isFloatingPoint!(T))
        {
            return format("RANGE: %.4f", result);
        }
        else
        {
            return format("RANGE: %d", result);
        }
    }
}

version(unittest)
{
    @Types!(short, int, long, float, double)
    void testSmallRange(T)()
    {
        Stats!T range = initStats!(T)("range");
        range.add(1);
        range.add(1);
        range.add(1);
        range.finish();
        static if (isFloatingPoint!(T))
        {
            range.toString().shouldEqual("RANGE: 0.0000");
        }
        else
        {
            range.toString().shouldEqual("RANGE: 0");
        }
    }
}
