# Define variables
CXX ?= g++
STRIP ?= strip
UPX ?= upx --ultra-brute
CXXFLAGS += -Wall -g
TARGET = tsid

ifeq ($(OS),Windows_NT)
LDLIBS += -llibglfw3 -lopengl32 -lglu32
EXE := .exe
else
LDLIBS += -lglfw -lGL -lGLU
EXE=
endif

SRCS := $(wildcard *.cpp v2mplayer/*.cpp)
OBJS = $(SRCS:.cpp=.o)
SHADERS := $(wildcard resource/*.glsl)

ifeq ($(RELEASE),1)
CXXFLAGS += -DNDEBUG -Oz -flto -fno-rtti
endif

.PHONY: all
all: $(TARGET)$(EXE) squish

.PHONY: squish
squish: $(TARGET)$(EXE)
ifeq ($(RELEASE),1)
	$(STRIP) $<
	-$(UPX) $<
endif

resource/shaders.h: $(SHADERS) | resource/glsl2h.sh
	bash resource/glsl2h.sh $^ > $@

$(TARGET)$(EXE): $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

main.o: resource/shaders.h

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJS) resource/shaders.h
