import {Player} from './Player'
 import {Board} from './Board'

export interface GameData 
{
    winner: string;
    player1: Player,
    player2: Player,
    currentPlayer: string,
    pieces: Board
}
