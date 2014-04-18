package mahjong;

/**
 * Created by alexism on 29/03/14.
 */
public class Point3d {
    private int x,y,z;

    public Point3d (int x, int y, int z){
        this.x = x;
        this.y = y;
        this.z = z;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Point3d point3d = (Point3d) o;

        if (x != point3d.x) return false;
        if (y != point3d.y) return false;
        if (z != point3d.z) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = x;
        result = 31 * result + y;
        result = 31 * result + z;
        return result;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getZ() {
        return z;
    }
}
