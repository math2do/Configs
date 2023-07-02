[build-menu]
FT_00_LB=_Compile
FT_00_CM=g++ "%f" -std=c++14 -O2 -o "%e" -Wall -Wextra -DLOCAL
FT_00_WD=
FT_01_LB=_Build
FT_01_CM=g++ "%f" -std=c++14 -O2 -o "%e" -Wall -Wextra -DLOCAL
FT_01_WD=
FT_02_LB=_Lint
FT_02_CM=cppcheck --language=c++ --enable=warning,style --template=gcc "%f"
FT_02_WD=
