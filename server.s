.intel_syntax noprefix
.global _start
_response:
push rbp
mov rbp, rsp
sub rsp, 20
mov byte PTR [rbp-2], 10
mov byte PTR [rbp-3], 13
mov byte PTR [rbp-4], 10
mov byte PTR [rbp-5], 13
mov byte PTR [rbp-6], 75
mov byte PTR [rbp-7], 79
mov byte PTR [rbp-8], 32
mov byte PTR [rbp-9], 48
mov byte PTR [rbp-10], 48
mov byte PTR [rbp-11], 50
mov byte PTR [rbp-12], 32
mov byte PTR [rbp-13], 48
mov byte PTR [rbp-14], 46
mov byte PTR [rbp-15], 49
mov byte PTR [rbp-16], 47
mov byte PTR [rbp-17], 80
mov byte PTR [rbp-18], 84
mov byte PTR [rbp-19], 84
mov byte PTR [rbp-20], 72
mov rax, 1
lea rsi, [rbp-20]
mov rdx, 19
syscall #write
mov rsp, rbp
pop rbp
ret
_get_filename:
push rbp
mov rbp, rsp
sub rsp, 8
mov qword ptr [rbp-8], rdi
_loop:
mov rcx, qword ptr [rbp-8]
cmp byte ptr [rcx], 32
je _reet
inc qword ptr [rbp-8]
jmp _loop
_reet:
mov rcx, qword ptr [rbp-8]
mov byte ptr [rcx], 0x0
mov rsp, rbp
pop rbp
ret
_read_write_file:
push rbp
mov rbp, rsp
sub rsp, 262
mov word ptr [rbp-260], di #fd to read from
mov word ptr [rbp-258], si #fd to write to
xor rax, rax
lea rsi, [rbp-256]
mov rdx, 256
syscall
mov word ptr [rbp-262], ax
mov rax, 3
syscall
xor rdi, rdi
mov di, word ptr [rbp-258]
call _response
mov rax, 1
xor rdi, rdi
mov di, word ptr [rbp-258]
lea rsi, [rbp-256]
mov dx, word ptr [rbp-262]
syscall
mov rsp, rbp
pop rbp
ret
_post:
push rbp
mov rbp, rsp
sub rsp, 14
mov qword ptr [rbp-8], rdi #buffer pointer 266
mov word ptr [rbp-10], si #buffer size
mov word ptr [rbp-12], dx #accept fd
lea rdi, [rdi + 5]
call _get_filename
mov rax, 2
mov rdi, [rbp-8]
add rdi, 5
mov rdx, 0x1ff
mov rsi, 65
syscall # open writing file
mov word ptr [rbp-14], ax
#write
mov rax, 1
xor rdi, rdi
mov di, word ptr [rbp-14]
mov rsi, [rbp-8]
add rsi, 182
xor rdx, rdx
mov dx, word ptr [rbp-10]
sub dx, 183
inc rdx
cmp byte ptr [rsi], 10
jne _continue
inc rsi
dec rdx
_continue:
syscall
xor rdi, rdi
mov di, word ptr [rbp-12]
xor rax, rax
mov rax, 3
xor rdi, rdi
mov di, word ptr [rbp-14]
syscall
xor rdi, rdi
mov di, word ptr [rbp-12]
call _response
mov rsp, rbp
pop rbp
ret
_start:
push rbp
mov rbp, rsp
sub rsp, 534
_create_socket:
xor rdi, rdi
mov rdi, 2
xor rsi, rsi
mov rsi, 1
xor rdx, rdx
mov rax, 41
syscall
_bind_socket:
mov word PTR [rbp-2], ax
mov rdi, rax
mov dword PTR [rbp-14], 0x0
mov word PTR [rbp-16], 0x5000
mov word PTR [rbp-18], 0x2
lea rsi, [rbp-18]
xor rdx, rdx
mov rdx, 0x10
xor rax, rax
mov rax, 49
syscall #bind
_listen:
mov rax, 50
mov di, word PTR [rbp-2]
mov rsi, 0x0
syscall #listen
_loop1:
mov rax, 43
xor rdi, rdi
mov di, word PTR [rbp-2]
mov rsi, 0x0
mov rdx, 0x0
syscall #accept
mov word ptr [rbp-20], ax
_fork:
mov rax, 57
xor rdi, rdi
syscall
cmp rax, 0
jne _close_socket
xor rdi, rdi
mov di, word ptr [rbp-2]
mov rax, 3
syscall #close socket fd
xor rax, rax
xor rdi, rdi
mov di, word ptr [rbp-20]
mov rdx, 512
lea rsi, [rbp-532]
syscall #read from the accepted socket
cmp byte ptr [rbp-532], 71
je _get
mov rsi, rax
xor rdx, rdx
mov dx, word ptr [rbp-20]
lea rdi, [rbp-532]
call _post
jmp _exit_child
_get:
lea rdi, [rbp-528]
call _get_filename
_open_response_file:
xor rax, rax
mov rax, 2
lea rdi, [rbp-528]
xor rsi, rsi
syscall
mov word ptr [rbp-534], ax
xor rdi, rdi
xor rsi, rsi
mov di, word ptr [rbp-534]
mov si, word ptr [rbp-20]
call _read_write_file
_close_socket_child:
mov rax, 3
xor rdi, rdi
mov di, word ptr [rbp-20]
syscall
_exit_child:
mov rax, 60
xor rdi, rdi
syscall
_close_socket:
mov rax, 3
xor rdi, rdi
mov di, word ptr [rbp-20]
syscall
jmp _loop1
_exit:
mov rax, 60
xor rdi, rdi
syscall
