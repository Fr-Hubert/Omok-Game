-- 五目ゲームの設定
board = {}
WHITE = 1
BLACK = 2
currentPlayer = BLACK -- 黒の石が最初に置かれる

function initBoard(size)
    for i = 1, size do
        board[i] = {}
        for j = 1, size do
            board[i][j] = 0 -- 空白は0
        end
    end
end

function placeStone(x, y)
    if board[x][y] == 0 then
        board[x][y] = currentPlayer
        if checkWin(currentPlayer) then
            printBoard() -- 勝利状態を出力
            print("Player " .. (currentPlayer == BLACK and "BLACK" or "WHITE") .. " wins!")
            os.exit() -- ゲーム終了
        end
        currentPlayer = (currentPlayer == BLACK) and WHITE or BLACK -- ターン変更
        return true
    end
    return false
end

function checkWin(player)
    return checkDirection(player, 1, 0) or -- 横
           checkDirection(player, 0, 1) or -- 縦
           checkDirection(player, 1, 1) or -- 斜め /
           checkDirection(player, 1, -1)    -- 斜め \
end

function checkDirection(player, dx, dy)
    local count = 0
    for i = 1, 15 do
        for j = 1, 15 do
            if board[i] and board[i][j] == player then
                count = count + 1
            else
                count = 0 -- 連続でない場合、カウントリセット
            end

            if count == 5 then
                return true -- 5つで勝利
            end

            -- 次の位置に移動
            i = i + dx
            j = j + dy
            if i < 1 or i > 15 or j < 1 or j > 15 then
                break -- 範囲を超えたら終了
            end
        end
    end
    return false
end

function printBoard()
    print("   a b c d e f g h i j k l m n o")
    for i = 1, 15 do
        io.write(string.format("%2d ", i)) -- 行番号を出力
        for j = 1, 15 do
            io.write((board[i][j] == 0 and "." or (board[i][j] == BLACK and "B" or "W")) .. " ") -- 空白は'.'、黒石は'B'、白石は'W'
        end
        print() -- 改行
    end
end

-- メインゲームループ
function main()
    initBoard(15) -- 15x15の五目盤を初期化
    while true do
        printBoard() -- 現在のボード状態を出力
        print("Current player: " .. (currentPlayer == BLACK and "BLACK" or "WHITE"))
        print("Enter your move (row and column, e.g., 1 a) or 'exit' to quit: ")

        local input = io.read() -- ユーザー入力
        
        if input == "exit" then
            print("Exiting the game.")
            os.exit() -- ゲーム終了
        end

        local row, col = input:match("(%d+)%s+([a-o])") -- 入力から行と列を抽出

        if row and col then
            row = tonumber(row)
            col = string.byte(col) - string.byte('a') + 1 -- 文字'a'を基準に列番号を計算
            if row >= 1 and row <= 15 and col >= 1 and col <= 15 then
                if not placeStone(row, col) then
                    print("Invalid move. Try again.")
                end
            else
                print("Invalid coordinates. Try again.")
            end
        else
            print("Invalid input. Please enter a valid move.")
        end
    end
end

main() -- ゲーム開始
