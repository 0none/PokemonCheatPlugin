# set default target
.DEFAULT_GOAL := PokemonCheatPlugin

# set name of plugin file
TARGETFILE = "cheat.plg"

# set some variables
CC = ${DEVKITARM}"/bin/arm-none-eabi-gcc"
CP = ${DEVKITARM}"/bin/arm-none-eabi-g++"
OC = ${DEVKITARM}"/bin/arm-none-eabi-objcopy"
LD = ${DEVKITARM}"/bin/arm-none-eabi-ld"
CTRULIB = '../libctru'

# building the plugin
PokemonCheatPlugin:
	@mkdir -p bin obj
	@#@python3 build.py
	@${CC} -Os -s  -g -I include -I include/libntrplg source/*.c source/battle/*.c source/rng/*.c -c  -march=armv6 -mlittle-endian
	@${CC} -Os source/*.s  -c -s -march=armv6 -mlittle-endian
	@${LD} -L ${DEVKITARM}/arm-none-eabi/lib/ -L obj  -pie --print-gc-sections  -T 3ds.ld -Map=homebrew.map *.o lib/*.o lib/*.a  -lc --nostdlib
	@cp -r *.o obj/.
	@cp a.out bin/homebrew.elf
	@${OC} -O binary a.out payload.bin -S
	@rm *.o
	@rm *.out
	@mv payload.bin ${TARGETFILE}
	@echo "successfully built to ${TARGETFILE}"

# cleaning the folder
clean:
	@rm -rf obj
	@rm -rf bin
	@rm -rf *.plg
	@rm -rf *.bin
	@rm -rf *.o
	@rm -rf *.out
