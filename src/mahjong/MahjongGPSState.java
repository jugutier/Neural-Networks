package mahjong;

import gps.api.GPSState;


import java.awt.*;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by jugutier on 18/03/14.
 */
public class MahjongGPSState implements GPSState {
    public MahjongBoard board;
    public List<Point> playables;
    MahjongGPSState(int matrix[][]){
        this.board = new MahjongBoard(matrix);
        playables = board.getPlayables();

    }
    @Override
    public boolean compare(GPSState state) {
        MahjongGPSState mState = ((MahjongGPSState)state);
        return board.equals(mState.board);
    }

    @Override
    public String toString() {
        StringBuffer out = new StringBuffer();
        for(int i=0; i< board.matrix.length; i++){
            out.append(" | ");
            for(int j=0; j<board.matrix[i].length ; j++){
                out.append(board.matrix[i][j]);
                out.append(" | ");
            }
            out.append('\n');
        }

        return out.toString();
    }

    /*
        Inner class representing a board. Defined as rectangular in a matrix for easy access.

     */
    class  MahjongBoard{
        int matrix[][];

        MahjongBoard(int matrix[][]){
            this.matrix = matrix;
        }

        @Override
        public boolean equals(Object o) {
            int m2[][] = ((MahjongBoard) o).matrix;
            for(int i=0; i< m2.length; i++){
                for(int j=0; j<m2[i].length ; j++){
                    if (m2[i][j] != matrix[i][j]){
                        return false;
                    }
                }
            }
            return true;
        }

        public List<Point> getPlayables(){
            List<Point> playables = new LinkedList<Point>();

            for (int i = 0; i < board.matrix.length; i++){
                for(int j = 0; j<board.matrix[i].length;j++){//the first available
                    if(matrix[i][j] != 0){
                        playables.add(new Point(i,j));
                        break;
                    }
                }
                for(int k = board.matrix[i].length-1; k>0;k--){//the last available
                    if(matrix[i][k] != 0){
                        playables.add(new Point(i,k));
                        break;
                    }
                }
            }
            return playables;
        }
    }
}
