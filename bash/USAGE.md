# pentest_prompt.sh

Prompt Bash + logging dành cho pentest. Tự chọn giữa **Oh My Posh** (lúc làm việc thường) và **prompt pentest** (khi đang có target/VPN/log). Kèm vài lệnh ghi và trích xuất log.

Trợ giúp nhanh trong terminal: `pthelp` (toàn bộ) hoặc `<command> -h` (một lệnh).


## Cài đặt

Chạy `setup.sh` ở gốc repo. Hoặc cài tay:

```bash
mkdir -p ~/.config/bash
cp bash/pentest_prompt.sh bash/USAGE.md ~/.config/bash/
echo '[[ -f ~/.config/bash/pentest_prompt.sh ]] && source ~/.config/bash/pentest_prompt.sh' >> ~/.bashrc
exec bash
```


## Prompt pentest

```
┌─[2026-11-15 11:56:02]─[✓]─[kali@kali]─[IP 192.168.1.5]─[VPN 10.10.14.5]─[TARGET 10.129.2.15 dc01]─[● REC]
└─[~/htb/academy/footprinting]$
```

Ô | Ý nghĩa
--- | ---
`2026-11-15 11:56:02` | Ngày giờ (phục vụ report, ảnh chụp màn hình có mốc thời gian)
`✓` / `✗ 1` | Lệnh trước thành công / thất bại kèm mã thoát
`kali@kali` | user@host. Xanh: user thường. Đỏ: root. Vàng: đang SSH
`IP 192.168.1.5` | IP máy ra Internet (chỉ hiện khi khác IP VPN)
`VPN 10.10.14.5` | IP interface VPN (tun0...). Đây là LHOST khi làm lab
`LHOST <ip> <dev>` | IP máy dùng để tới target (hiện khi khác VPN: pentest tại chỗ, pivot)
`TARGET 10.129.2.15 dc01` | Target hiện tại
`● REC` | Đang ghi log bằng startlog


## Lệnh

### settarget / cleartarget
```bash
settarget <ip> [name]          # đặt target. Vd: settarget 10.129.2.15 dc01
nmap -sV $ip                   # $ip = $TARGET = IP vừa đặt (khỏi gõ lại IP)
msfvenom ... LHOST=$LHOST       # $LHOST = IP máy bạn mà target kết nối về (reverse shell)
cleartarget                    # xoá target
```
Target được lưu ra `~/.config/bash/.target`, nên mọi terminal mới đều tự nhận.

### startlog
```bash
startlog footprinting          # ghi cả lệnh lẫn output
# ... làm việc ...
exit                           # dừng ghi
```
File lưu ở `~/pentest_logs/<ngày>/<giờ>_<tên>.log` kèm `.timing`.
- Xem lại: `less -R <file>.log`
- Phát lại như video: `scriptreplay <file>.timing <file>.log`

### histgrep
```bash
histgrep nmap                  # tìm mọi lệnh nmap đã chạy, kèm ngày giờ
```

### cutlines
Cắt một đoạn dòng từ file (thường là log) ra file mới:
```bash
cutlines [-c] <source> <from> <to|$> <dest>
```
- `source`: file nguồn. `dest`: file đích (tự tạo thư mục nếu chưa có).
- `from` / `to`: dòng bắt đầu / kết thúc. `to = $` -> tới cuối file.
- `-c`: bỏ mã màu, để dán vào note `.md` cho sạch.
```bash
grep -n nmap ~/pentest_logs/2026-11-15/115602_dc01.log   # tìm số dòng
cutlines -c ~/pentest_logs/2026-11-15/115602_dc01.log 120 245 ~/htb/dc01/nmap.txt
```

### prompt-mode
```bash
prompt-mode              # xem chế độ hiện tại
prompt-mode pentest      # luôn dùng prompt pentest
prompt-mode omp          # luôn dùng Oh My Posh
prompt-mode auto         # tự chọn (mặc định)
```


## Biến cấu hình

Đặt **trước** dòng `source` trong `~/.bashrc`:

Biến | Mặc định | Ý nghĩa
--- | --- | ---
`PT_VPN_IF` | `tun0 tun1 wg0 ppp0 tailscale0` | Danh sách interface VPN, lấy cái đầu tiên có IP
`PT_LOG_DIR` | `~/pentest_logs` | Thư mục chứa log
`PT_OMP_CONFIG` | `~/.config/oh-my-posh/theme.omp.json` | File theme Oh My Posh
`PT_ASCII` | (trống) | Đặt `=1` để ép khung ASCII, tắt Unicode
`PROMPT_STYLE` | `auto` | `auto` / `pentest` / `omp`

Ví dụ cho VPN dùng WireGuard:
```bash
PT_VPN_IF="wg0 tun0"
source ~/.config/bash/pentest_prompt.sh
```


## Ghi chú

- Gõ một **dấu cách ở đầu lệnh** thì lệnh đó không bị lưu vào history (dùng khi lệnh chứa mật khẩu/token).
- Thiếu lệnh `ip`: phần mạng tự ẩn, prompt vẫn chạy. Thiếu `script`: `startlog` báo lỗi rõ. Thiếu `col`: `cutlines -c` vẫn chạy.
- Chế độ `auto` chuyển sang prompt pentest khi: đã settarget, đang startlog, VPN đã kết nối, đang SSH, hoặc ở tty thuần.