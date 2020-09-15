# project parameters
NAME=doorbell
BOARD=stm8s105k6
PROGRAMMER=stlinkv2
EFORTH=stm8_eforth/

# use SDCC toolchain
SDAS=sdasstm8
SDCC=sdcc
CFLAGS=-mstm8 -lstm8  -I$(EFORTH)inc

# programmer tool
FLASH=stm8flash

# sources files 
BUILD=build/
OBJECTS=$(BUILD)$(SRC:.f=.rel)
SYMBOLS=$(OBJECTS:.rel=.sym)
LISTS=$(OBJECTS:.rel=.lst)

.PHONY: all

all: clean $(NAME).rel $(NAME).ihx 

.PHONY: clean 

clean: build
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	-rm -f $(BUILD)*


clear_eevars:
	@echo
	@echo "**********************"
	@echo "erase EEPROM variables"
	@echo "**********************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s eeprom -b 16 -w /dev/zero

build:
	mkdir build

flash: clear_eevars $(LIB)
	@echo
	@echo "***************"
	@echo "flashing device"
	@echo "***************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(BUILD)$(NAME).ihx 

doorbell: $(MAIN_FILE) $(SRC) $(INCLUDE)
	@echo
	@echo "***************"
	@echo "cleaning build directory"
	@echo "***************"
	-rm build/*
	@echo
	@echo "**********************"
	@echo "erase EEPROM variables"
	@echo "**********************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s eeprom -b 16 -w /dev/zero
	@echo
	@echo "***************"
	@echo "linking files"
	@echo "***************"
	$(SDCC) $(CFLAGS) -Wl-u -o $(BUILD)$(NAME).ihx  $(EFORTH)build/eForth.rel
	@echo
	@echo "***************"
	@echo "flashing device"
	@echo "***************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(BUILD)$(NAME).ihx


read_eevars:
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -s eeprom -b 16 -r eevars.bin
	@hexdump -C eevars.bin 
	@rm eevars.bin 
