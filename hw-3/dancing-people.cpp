
#include <iostream>
#include <thread>
#include <chrono>
#include <iostream>
#include <string>
#include <vector>
#include <mutex>
#include <algorithm>
#include <sstream>
using namespace std;

mutex symb;
string toSymb(char s)
{
	symb.lock();
	string alph[26] = { "a","b","c","d","e","f", "g","h", "i","j", "k","l", "m","n", "o","p", "q","r","s","t","u","v","w","x","y","z" };
	string decode_alph[26] = { "5","2","=","+","8","1", "3","4", "6","7", "{","0", "9","*", "#","●", "}","(",")",";","?","▢","]",".",":","," };
	int index = 555;
	for (int i = 0; i < 26; i++)
	{
		string new_s(1, s);
		if (alph[i] == new_s)
		{
			index = i;
		}
	}

	cout << "ID of thread " << this_thread::get_id() << " " << s << " to " << decode_alph[index] << "\n";
	symb.unlock();
	return decode_alph[index];

}
char asciitolower(char in) {
	if (in <= 'Z' && in >= 'A')
		return in - ('Z' - 'z');
	return in;
}
vector<string> split(const string& s, char delim) {
	vector<string> result;
	stringstream ss(s);
	string item;

	while (getline(ss, item, delim)) {
		result.push_back(item);
	}

	return result;
}
bool chech_for_latin(vector<string> v)
{
	for (int i = 0; i < v.size(); i++)
	{
		for (int j = 0; j < v[i].size(); j++)
		{
			if (!((v[i][j] >= 'a' && v[i][j] <= 'z') || (v[i][j] >= 'A' && v[i][j] <= 'Z')))
			{
				throw exception();
			}
		}
	}
	return true;
}


int main()
{
	string input;
	cout << "Input some text:\n";
	getline(std::cin, input);

	vector<string> v = split(input, ' ');

	try
	{
		chech_for_latin(v);
	}
	catch (const std::exception&)
	{
		cout << "Only Latin letters are allowed!";
		return 0;
	}

	string result = "";
	for (int i = 0; i < v.size(); i++)
	{
		std::transform(v[i].begin(), v[i].end(), v[i].begin(), asciitolower);
		char const* ca = v[i].c_str();

		int n = strlen(ca);
		for (int i = 0; i < n; i++)
		{
			std::thread t1([&result, ca, i]()
				{

					result += toSymb(ca[i]);
				});
			t1.join();
		}
		result += " ";
	}
	cout << "\n\"" << input << "\"" << " encoded to " << "\"" << result << "\"\n";
}

