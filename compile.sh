echo "Compiling to binary..."
nasm -f bin -o snake.bin snake.asm

echo "Copying compiled binary to img file"
dd if=/dev/zero of=snake.img ibs=1k count=1440
dd if=snake.bin of=snake.img conv=notrunc

echo "Tidying up..."
rm snake.bin

echo "Successfully compiled snake.img"
