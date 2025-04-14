#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>  // for std::min and std::max

using namespace std;

// Cek apakah file/brightness path tersedia
bool path_exists(const string &path) {
    ifstream file(path);
    return file.good();
}

// Fungsi untuk baca nilai brightness
int read_brightness(const string &path) {
    ifstream file(path);
    int value;
    file >> value;
    return value;
}

// Fungsi untuk tulis nilai brightness
void write_brightness(const string &path, int value) {
    ofstream file(path);
    if (!file.is_open()) {
        cerr << "Gagal membuka " << path << " untuk ditulis." << endl;
        exit(1);
    }
    file << value;
    if (file.fail()) {
        cerr << "Gagal menulis nilai ke " << path << "." << endl;
        exit(1);
    }
}

int main(int argc, char *argv[]) {
    string base_path = "";

    // Deteksi urutan prioritas: intel → amd → radeon → acpi
    if (path_exists("/sys/class/backlight/intel_backlight/brightness")) {
        base_path = "/sys/class/backlight/intel_backlight/";
    } else if (path_exists("/sys/class/backlight/amdgpu_bl0/brightness")) {
        base_path = "/sys/class/backlight/amdgpu_bl0/";
    } else if (path_exists("/sys/class/backlight/radeon_bl0/brightness")) {
        base_path = "/sys/class/backlight/radeon_bl0/";
    } else if (path_exists("/sys/class/backlight/acpi_video0/brightness")) {
        base_path = "/sys/class/backlight/acpi_video0/";
    } else {
        cerr << "Tidak ditemukan device backlight yang dikenali." << endl;
        return 1;
    }

    string brightness_path = base_path + "brightness";
    string max_brightness_path = base_path + "max_brightness";

    int max_brightness = read_brightness(max_brightness_path);
    int step = max(1, max_brightness / 20);  // agar step minimal tetap 1
    int current = read_brightness(brightness_path);
    int new_value = current;

    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " [up|down]" << endl;
        return 1;
    }

    string cmd = argv[1];
    if (cmd == "up") {
        new_value = min(current + step, max_brightness);
    } else if (cmd == "down") {
        new_value = max(current - step, 0);
    } else {
        cerr << "Usage: " << argv[0] << " [up|down]" << endl;
        return 1;
    }

    write_brightness(brightness_path, new_value);
    cout << "Brightness changed to: " << new_value << " / " << max_brightness << endl;

    return 0;
}
