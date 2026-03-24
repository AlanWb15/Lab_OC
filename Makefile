sudo apt update
sudo apt install nasm

nasm -f elf64 src\suma.asm -o src\suma.o

nothing:
	echo "nada"

salvar: 
	git status
	git add .
	git commit -m "salvar cambios"
	git push
	