#ifndef TIMER_H
#define TIMER_H

#include <cstdint>

class Timer	// high resolution timer
	{
	protected:
		int64_t timerFrequency;
		int64_t startCount;
		int64_t endCount;
		int64_t beginCount;
		int64_t currentCount;
		double tfreq;
		double time;
		double tstart;
		double tstop;
		double tbegin;
		double tcurrent;
	public:
		Timer(void);
		~Timer(void);
		double tcorrection;
		void starttimer(void);
		void stoptimer(void);
		void update(void);
		float elapsed;
		float dt;
	};

#endif
