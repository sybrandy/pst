module stats.count;

import std.stdio, std.conv, std.format;
import stats, common.options;

version(unittest)
{
    import unit_threaded;
}

class Count(T) : Stats!(T)
{
    ulong result;

    this(Options opts)
    {
    }

    void add(T val)
    {
        result++;
    }

    void finish()
    {
    }

    override string toString()
    {
        return format("COUNT: %d", result);
    }
}

version(unittest)
{
    @(1, 2, 5, 7, 11, 23)
    void testCount(int currLen)
    {
        Options opts;
        Stats!int count = initStats!(int)("count", opts);
        foreach (i; 0..currLen)
        {
            count.add(1);
        }
        count.finish();
        count.toString().shouldEqual("COUNT: " ~ to!(string)(currLen));
    }
}
