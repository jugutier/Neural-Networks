package mahjong;

import gps.api.GPSState;

import java.awt.*;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by jugutier on 18/03/14.
 */
public class MahjongGPSState implements GPSState {
    public MahjongBoard board;
    public List<Point3d> playables;
    public int lastSymbol;
/*
* @param lastSymbol: last value used to represent the greatest tile within the matrix*/
    MahjongGPSState(int matrix[][][]) {
        this.board = new MahjongBoard(matrix);
        playables = board.getPlayables();
    }

    @Override
    public boolean compare(GPSState state) {
        MahjongGPSState mState = ((MahjongGPSState) state);
        return board.equals(mState.board);
    }

    @Override
    public String toString() {
        StringBuffer out = new StringBuffer();
        for(int k = 0; k < board.matrix[0][0].length; k++){
            out.append("Level: " + k + "\n");
            for (int i = 0; i < board.matrix.length; i++) {
                out.append(" | ");
                for (int j = 0; j < board.matrix[i].length; j++) {
                    out.append(board.matrix[i][j][k]);
                    out.append(" | ");
                }
                out.append('\n');
            }
        }
        return out.toString();
    }

    public Integer playablePairs() {
        int retVal = 0;
        List<Point3d> playables = board.getPlayables();
        int[] symbolsCount = new int[lastSymbol];
        for (Point3d p : playables) {
            symbolsCount[board.matrix[p.getX()][p.getY()][p.getZ()] - 1]++;
        }
        for (int currentSymbol : symbolsCount) {
            retVal += Math.floor(currentSymbol / 2);
        }
        return retVal;
    }

    public void setLastSymbol(int lastSymbol) {
        this.lastSymbol = lastSymbol;
    }

    /*
        Inner class representing a board. Defined as rectangular in a matrix for easy access.

     */
    class MahjongBoard {
        int matrix[][][];

        MahjongBoard(int matrix[][][]) {
            this.matrix = matrix;
        }

        @Override
        public boolean equals(Object o) {
            int m2[][][] = ((MahjongBoard) o).matrix;
            for (int i = 0; i < m2.length; i++) {
                for (int j = 0; j < m2[i].length; j++) {
                    for (int k = 0; k < m2[0][0].length; k++) {
                        if (m2[i][j][k] != matrix[i][j][k]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        // Returns a list of points where are playable tiles. The answer does not say
        // in which z-level the playable tile is.
        public List<Point3d> getPlayables() {
            List<Point3d> playables = new LinkedList<Point3d>();

            for (int i = 0; i < board.matrix.length; i++) {
                for (int j = 0; j < board.matrix[i].length; j++) {//the first available
                    for(int k = 0; k < board.matrix[i][j].length; k++) {
                        if (matrix[i][j][k] != 0) {
                            if(k == board.matrix[i][j].length-1 || matrix[i][j][k+1] == 0){
                                if(j == 0 || j == board.matrix[0].length-1){
                                    playables.add(new Point3d(i, j, k));
                                }else if(matrix[i][j-1][k] == 0 || matrix[i][j+1][k] == 0){
                                    playables.add(new Point3d(i, j, k));
                                }
                            }
                        }
                    }
                }
            }
            return playables;
        }
    }
}
