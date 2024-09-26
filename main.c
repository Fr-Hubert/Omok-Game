#include <stdio.h>
#include <stdlib.h> // system関数を使用するために追加
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

// Luaスクリプトを実行する関数
void initGame(lua_State *L) {
    if (luaL_dofile(L, "omok.lua") != LUA_OK) {
        // エラーメッセージを出力し、スタックからエラーを削除
        fprintf(stderr, "Error: %s\n", lua_tostring(L, -1));
        lua_pop(L, 1); // エラーメッセージをスタックから削除
    }
}

int main() {
    lua_State *L = luaL_newstate(); // Lua状態を生成
    luaL_openlibs(L); // Luaライブラリを開く
    
    initGame(L); // ゲームを初期化

    printf("Press any key to exit...\n"); // 終了前にメッセージを出力
    system("pause"); // ユーザー入力を待機

    lua_close(L); // Lua状態を閉じる
    return 0;
}
