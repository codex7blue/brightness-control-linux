#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>

using namespace std;

int read_brightness(const string &path) {
    ifstream file(path);
    int value;
    file >> value;
    return value;
}

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
    string path = "/sys/class/backlight/intel_backlight/";
    string max_brightness_path = path + "max_brightness";
    string brightness_path = path + "brightness";

    int max_brightness = read_brightness(max_brightness_path);
    int step = max_brightness / 20;
    int current_brightness = read_brightness(brightness_path);
    int new_brightness = current_brightness;

    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " [up|down]" << endl;
        return 1;
    }

    string command = argv[1];
    if (command == "up") {
        new_brightness += step;
        if (new_brightness > max_brightness)
            new_brightness = max_brightness;
    } else if (command == "down") {
        new_brightness -= step;
        if (new_brightness < 0)
            new_brightness = 0;
    } else {
        cerr << "Usage: " << argv[0] << " [up|down]" << endl;
        return 1;
    }

    write_brightness(brightness_path, new_brightness);
    return 0;
}
