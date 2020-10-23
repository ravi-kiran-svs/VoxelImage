class CameraOrthographic	{

	Vector u, v, w;

	public CameraOrthographic(Vector u, Vector v, Vector w)	{
		this.u = u;
		this.v = v;
		this.w = w;
	}

	public float[][] getTransformationalMatrix()	{
		return Matrix.getTransformationalMatrixXYZ(u, v, w);
	}

	public float[][] getInverseTransformationalMatrix()	{
		return Matrix.inverse33(getTransformationalMatrix());
	}

}