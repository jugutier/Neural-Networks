package mahjong;

import gps.GPSEngine;
import gps.GPSNode;

/**
 * Created by jugutier on 19/03/14.
 */
public class MahjongGPSEngine extends GPSEngine {
    @Override
    public void addNode(GPSNode node) {

        open.add(node);

    }
}
