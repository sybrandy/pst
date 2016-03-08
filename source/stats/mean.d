module stats.mean;

import std.stdio, std.traits, std.math, std.conv;
version(unittest)
{
    import unit_threaded;
}

struct Mean(T)
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

@("Very simple test case (int)")
unittest
{
    Mean!int intMean;
    intMean.add(1);
    intMean.add(1);
    intMean.add(1);
    intMean.flush.shouldEqual(1);
}

@("Simple test case (int)")
unittest
{
    Mean!int intMean;
    intMean.add(1);
    intMean.add(2);
    intMean.add(3);
    intMean.flush.shouldEqual(2);
}

@("Very simple test case (long)")
unittest
{
    Mean!long longMean;
    longMean.add(1);
    longMean.add(1);
    longMean.add(1);
    longMean.flush.shouldEqual(1);
}

@("Simple test case (long)")
unittest
{
    Mean!long longMean;
    longMean.add(1);
    longMean.add(2);
    longMean.add(3);
    longMean.flush.shouldEqual(2);
}

@("Very simple test case (ushort)")
unittest
{
    Mean!ushort ushortMean;
    ushortMean.add(1);
    ushortMean.add(1);
    ushortMean.add(1);
    ushortMean.flush.shouldEqual(1);
}

@("Simple test case (ushort)")
unittest
{
    Mean!ushort ushortMean;
    ushortMean.add(1);
    ushortMean.add(2);
    ushortMean.add(3);
    ushortMean.flush.shouldEqual(2);
}

@("Very simple test case (float)")
unittest
{
    Mean!float floatMean;
    floatMean.add(1.0);
    floatMean.add(1.0);
    floatMean.add(1.0);
    floatMean.total.shouldEqual(3.0);
    floatMean.numVals.shouldEqual(3.0);
    floatMean.flush.shouldEqual(1.0);
}

@("Simple test case (float)")
unittest
{
    Mean!float floatMean;
    floatMean.add(1.0);
    floatMean.add(2.0);
    floatMean.add(3.0);
    floatMean.total.shouldEqual(6.0);
    floatMean.numVals.shouldEqual(3.0);
    floatMean.flush.shouldEqual(2.0);
}

@("Very simple test case (double)")
unittest
{
    Mean!double doubleMean;
    doubleMean.add(1.0);
    doubleMean.add(1.0);
    doubleMean.add(1.0);
    doubleMean.total.shouldEqual(3.0);
    doubleMean.numVals.shouldEqual(3.0);
    doubleMean.flush.shouldEqual(1.0);
}

@("Simple test case (double)")
unittest
{
    Mean!double doubleMean;
    doubleMean.add(1.0);
    doubleMean.add(2.0);
    doubleMean.add(3.0);
    doubleMean.total.shouldEqual(6.0);
    doubleMean.numVals.shouldEqual(3.0);
    doubleMean.flush.shouldEqual(2.0);
}
