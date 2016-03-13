module stats.mean;

import std.stdio, std.traits, std.math, std.conv;
import stats;

version(unittest)
{
    import unit_threaded;
}

class Mean(T) : Stats!(T)
{
    static if (isFloatingPoint!(T))
    {
        double total;
    }
    else
    {
        static if (isSigned!(T))
        {
            long total;
        }
        else
        {
            static if (isNumeric!(T))
            {
                ulong total;
            }
        }
    }
    ulong numVals;
    void add(T val)
    {
        static if (isFloatingPoint!(T))
        {
            if (isNaN(total))
            {
                total = 0.0;
            }
        }
        total += val;
        numVals++;
    }

    T flush()
    {
        return to!(T)(total / numVals);
    }
}

@Types!(short, int, long, float, double)
void testVerySimpleCase(T)()
{
    Stats!T mean = initStats!(T)("mean");
    mean.add(1);
    mean.add(1);
    mean.add(1);
    mean.flush.shouldEqual(1);
}

@Types!(short, int, long, float, double)
void testSimpleCase(T)()
{
    Stats!T mean = initStats!(T)("MEAN");
    mean.add(1);
    mean.add(2);
    mean.add(3);
    mean.flush.shouldEqual(2);
}
