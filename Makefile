TARGETS=twiboot mpmboot funkboot twiboot_serial
TARGET_DIR=~/bin
BUILD_DIR = build

CFLAGS= -pipe -O2 -Wall -Wno-unused-result
CFLAGS+= -MMD -MP -MF $(BUILD_DIR)/$(*D)/$(*F).d
LDFLAGS=-lserialport

# ------

SRC:= $(wildcard *.c)

all: $(TARGETS)

$(TARGETS): $(patsubst %,$(BUILD_DIR)/%, $(SRC:.c=.o))
	@echo " Linking file:  $@"
	@$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS) > /dev/null

$(BUILD_DIR)/%.o: %.c $(MAKEFILE_LIST)
	@echo " Building file: $<"
	@$(shell test -d $(BUILD_DIR)/$(*D) || mkdir -p $(BUILD_DIR)/$(*D))
	@$(CC) $(CFLAGS) -o $@ -c $<

clean:
	rm -rf $(BUILD_DIR) $(TARGETS)

install: $(TARGETS)
	@mkdir -p $(TARGET_DIR)
	rm -f $(patsubst %,$(TARGET_DIR)/%, $(TARGETS))
	cp -a $^ $(TARGET_DIR)

install_links: $(TARGETS)
	@mkdir -p $(TARGET_DIR)
	rm -f $(patsubst %,$(TARGET_DIR)/%, $(TARGETS))
	ln -s -t $(TARGET_DIR) $(patsubst %,$(PWD)/%, $(TARGETS))

-include $(shell find $(BUILD_DIR) -name \*.d 2> /dev/null)
