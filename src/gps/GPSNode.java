package gps;

import gps.api.GPSState;

public class GPSNode {

	private GPSState state;

	private GPSNode parent;

	private Integer cost;

    private Integer depth;

	public GPSNode(GPSState state, Integer cost) {
		super();
		this.state = state;
		this.cost = cost;
        this.depth = null;
	}

	public GPSNode getParent() {
		return parent;
	}

	public void setParent(GPSNode parent) {
		this.parent = parent;
        this.depth = parent.depth + 1;
	}

	public GPSState getState() {
		return state;
	}

	public Integer getCost() {
		return cost;
	}

    public void setDepth(int depth) {
        this.depth = depth;
    }

    public Integer getDepth() {
        return this.depth;
    }

	@Override
	public String toString() {
		return state.toString();
	}

	public String getSolution() {
		if (this.parent == null) {
			return this.state.toString();
		}
		return this.parent.getSolution() + "\n" + this.state;
	}
}
