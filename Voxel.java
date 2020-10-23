class Voxel	{

	Vector p;
	VoxelImage.VoxelDrawer drawer;

	public Voxel(float x, float y, float z, VoxelImage.VoxelDrawer voxelDrawer)	{
		p = new Vector(x, y, z);
		drawer = voxelDrawer;
	}

	public boolean equals(Voxel v) {
		return p.equals(v.p);
	}

	public void draw(float[][] M)	{
		drawer.onVoxelDraw(Matrix.vXm33(p, M));
	}

}