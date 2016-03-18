module runner;

interface Runner(T)
{
    void addMetric(string name);
    void put(T value);
    void finish();
    string getOutput();
}
