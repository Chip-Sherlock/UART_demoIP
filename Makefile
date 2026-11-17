
SHELL := /bin/bash
.PHONY: build clean

build:
	cat mutdef.txt > mutation_defult.sv
	echo "package mut;" > mutations.sv
	sed -i '/^[[:space:]]*$$/d' config.txt
	sed '2,$$s/[[:space:]]*$$/ ;/' config.txt > mut.txt
	sed -i '2,$$s/^/parameter /' mut.txt
	sed -i '1r mut.txt' mutations.sv
	sed -i '$$a\endpackage' mutations.sv
	while read -r name value; do \
		sed -i -E "s/^([[:space:]]*parameter[[:space:]]+$$name[[:space:]]*=[[:space:]]*)[^;]+/\1$$value/" mutation_defult.sv; \
	done < <(sed -nE 's/^[[:space:]]*parameter[[:space:]]+(m[0-9]+)[[:space:]]*=[[:space:]]*([0-9]+)[[:space:]]*;.*/\1 \2/p' mutations.sv)
	@echo "Running SVase..."
	@{ cat mutation_defult.sv; printf '\n'; cat uart_tx.sv; } > /root/svase/uart_tx_input.sv
	@cd /root/svase && ./build/svase uart_tx /mnt/d/NVDLA/UART/UART/uart_tx_elaborated.sv /root/svase/uart_tx_input.sv
	@echo "SVase elaboration completed."

clean:
	cat mutdef.txt > mutation_defult.sv
