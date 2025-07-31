#include "timer.h"

#ifdef _WIN32
#include <profileapi.h>

static int64_t GetFrequency()
{
	LARGE_INTEGER frequency = {};
	QueryPerformanceFrequency(&frequency);
	return frequency.QuadPart;
}

static int64_t GetCounter()
{
	LARGE_INTEGER counter = {};
	QueryPerformanceCounter(&counter);
	return counter.QuadPart;
}

#else
#include <time.h>
constexpr int64_t NS_PER_SEC = 1000000000LL;

static int64_t GetFrequency()
{
	return NS_PER_SEC;
}

static int64_t GetCounter()
{
	int64_t ticks;
#ifdef __linux__
	struct timespec now;

	clock_gettime(CLOCK_MONOTONIC, &now);
	ticks = now.tv_sec;
	ticks *= NS_PER_SEC;
	ticks += now.tv_nsec;
#elif __APPLE__
	ticks = mach_absolute_time();
#else
	ticks = 0;
#endif
	return ticks;
}
#endif

Timer::Timer()
	{
	timerFrequency=GetFrequency();
	tfreq=(double)timerFrequency;
	// calibration
	starttimer();
	stoptimer();
	tcorrection=(double)(endCount-startCount);
	tbegin=tstart;
	}

Timer::~Timer()
	{}

void Timer::starttimer(void)
	{
	time=0.0;
	startCount=GetCounter();
	tstart=(double)startCount;
	}

void Timer::stoptimer(void)
	{
	endCount=GetCounter();
	tstop=(double)endCount;
	}

void Timer::update(void)
	{
	stoptimer();
	dt=(float)((tstop-tstart-tcorrection)/(tfreq));
	elapsed=(float)((tstop-tbegin)/tfreq);
	starttimer();
	}
