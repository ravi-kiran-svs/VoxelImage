import java.util.ArrayList;

PImage[] images = new PImage[3];
CameraOrthographic cam;
ArrayList<Voxel> voxels = new ArrayList();

final Vector origin = new Vector(400, 300, 0);
boolean[] isKeyOn = new boolean[] {false, false, false, false};

/*
The 3 images should be stored in /data as "common-name_number", number 1, 2, 3 respectively.
Modify the below variable to the common-name
*/
//String fileSet = "trinity-128";
String fileSet = "witcher_wolf-256";
/*
Recommended resolution = 128*128.
Higher resolutions take time to load and are slower.
Change the below variable to the resolution when changed.
Recommended resolution to be in power of 2.
*/
int resolution = 256;
/*
When the below variable is true, the camera moves in a predefined path.
When false, user can manually control using the arrow keys and '1', '2', '3' keys to re-orient the camera.
*/
boolean autoRotate = true;
float speed = 0.05;

int timeDelay = (int) (5000/speed);
float pixelSpeed = speed/100;
int l = resolution/2;

color bg = color(13, 0, 13);
color stroke = color(128, 255, 255);

void setup()	{

	size(800, 600);
	stroke(stroke);
	frameRate(1);

	images[0] = loadImage(fileSet + "_" + 1 + ".png");
	images[1] = loadImage(fileSet + "_" + 2 + ".png");
	images[2] = loadImage(fileSet + "_" + 3 + ".png");

	cam = new CameraOrthographic(
		new Vector(0, 0, -1), 
		new Vector(0, 1, 0), 
		new Vector(1, 0, 0)
	);

	for(int y = l-1; y >= -l; y--)	{
		for(int x = -l; x < l; x++)	{
			int p = (l-1 - y)*2*l + (l + x);
			color c = images[0].pixels[p];
			if (red(c) == 0) {
				ArrayList<Integer> filled = new ArrayList();
				for(int z = -l; z < l; z++)	{

					int p1 = (l-1 - y)*2*l + (l + z);
					color c1 = images[1].pixels[p1];

					int p2 = (l-1 - x)*2*l + (l + z);
					color c2 = images[2].pixels[p2];

					if (red(c1) == 0 && red(c2) == 0) {
						filled.add(z);
					}
				}

				Voxel voxel;
				if (filled.size() > 0) {
					int fill = (int) random(filled.size());
					voxel = new Voxel(filled.get(fill), y, -x - 1, voxelDraw);
				}else {
					int fill = (int) random(2*l);
					fill -= l;
					voxel = new Voxel(fill, y, -x - 1, voxelDraw);
				}
				voxels.add(voxel);
			}
		}
	}

	for(int y = l-1; y >= -l; y--)	{
		for(int x = -l; x < l; x++)	{
			int p = (l-1 - y)*2*l + (l + x);
			color c = images[1].pixels[p];
			if (red(c) == 0) {
				boolean pixelExists = false;
				for(Voxel voxel : voxels)	{
					int x1 = (int) voxel.p.x;
					int y1 = (int) voxel.p.y;

					if (x1 == x && y1 == y) {
						pixelExists = true;
						break;
					}
				}

				if (!pixelExists) {
					ArrayList<Integer> filled = new ArrayList();
					for(int z = -l; z < l; z++)	{

						int p1 = (l-1 - z)*2*l + (l + x);
						color c1 = images[2].pixels[p1];

						int p2 = (l-1 - y)*2*l + (l + z);
						color c2 = images[0].pixels[p2];

						if (red(c1) == 0 && red(c2) == 0) {
							filled.add(z);
						}
					}

					Voxel voxel;
					if (filled.size() > 0) {
						int fill = (int) random(filled.size());
						voxel = new Voxel(x, y, -filled.get(fill) - 1, voxelDraw);
					}else {
						int fill = (int) random(2*l);
						fill -= l;
						voxel = new Voxel(x, y, fill, voxelDraw);
					}
					voxels.add(voxel);
				}
			}
		}
	}

	for(int y = l-1; y >= -l; y--)	{
		for(int x = -l; x < l; x++)	{
			int p = (l-1 - y)*2*l + (x + l);
			color c = images[2].pixels[p];
			if (red(c) == 0) {
				boolean pixelExists = false;
				for(Voxel voxel : voxels)	{
					int x1 = (int) voxel.p.x;
					int y1 = (int) -voxel.p.z - 1;

					if (x1 == x && y1 == y) {
						pixelExists = true;
						break;
					}
				}

				if (!pixelExists) {
					ArrayList<Integer> filled = new ArrayList();
					for(int z = -l; z < l; z++)	{

						int p1 = (l-1 - z)*2*l + (l + y);
						color c1 = images[0].pixels[p1];

						int p2 = (l-1 - z)*2*l + (l + x);
						color c2 = images[1].pixels[p2];

						if (red(c1) == 0 && red(c2) == 0) {
							filled.add(z);
						}
					}

					Voxel voxel;
					if (filled.size() > 0) {
						int fill = (int) random(filled.size());
						voxel = new Voxel(x, filled.get(fill), -y - 1, voxelDraw);
					}else {
						int fill = (int) random(2*l);
						fill -= l;
						voxel = new Voxel(x, fill, -y - 1, voxelDraw);
					}
					voxels.add(voxel);
				}
			}
		}
	}

	println("Number of Voxel elements: " + voxels.size());

}

void draw()	{

	if (autoRotate) {
		int time = millis();
		time = time%(timeDelay*6);

		if (time < timeDelay) {
			cam.u.change(0, 0, -1);
			cam.v.change(0, 1, 0);
			cam.w.change(1, 0, 0);
			
		}else if (time < 2*timeDelay) {
			float t = ((float)time)/timeDelay - 1;
			t = -2*t*t*t + 3*t*t;
			float theta = map(t, 0, 1, 0, PI/2);
			cam.u.change(sin(theta), 0, -cos(theta));
			cam.v.change(0, 1, 0);
			cam.w.change(cos(theta), 0, sin(theta));
			
		}else if (time < 3*timeDelay) {
			cam.u.change(1, 0, 0);
			cam.v.change(0, 1, 0);
			cam.w.change(0, 0, 1);
			
		}else if (time < 4*timeDelay) {
			float t = ((float)time)/timeDelay - 3;
			t = -2*t*t*t + 3*t*t;
			float theta = map(t, 0, 1, 0, PI/2);
			cam.u.change(1, 0, 0);
			cam.v.change(0, cos(theta), -sin(theta));
			cam.w.change(0, sin(theta), cos(theta));
			
		}else if (time < 5*timeDelay) {
			cam.u.change(1, 0, 0);
			cam.v.change(0, 0, -1);
			cam.w.change(0, 1, 0);
			
		}else if (time < 6*timeDelay) {
			float t = ((float)time)/timeDelay - 5;
			t = -2*t*t*t + 3*t*t;
			float theta = map(t, 0, 1, 0, PI/2);
			cam.u.change(cos(theta)*cos(theta), -sin(theta)*cos(theta), -sin(theta));
			cam.v.change(-sin(theta)*cos(theta), sin(theta)*sin(theta), -cos(theta));
			cam.w.change(sin(theta), cos(theta), 0);
			
		}
		
	}else {
		int x = (isKeyOn[1]? 1: 0) - (isKeyOn[3]? 1: 0);
		int y = (isKeyOn[0]? 1: 0) - (isKeyOn[2]? 1: 0);
		Vector input = new Vector(x, y, 0);
		input.normalize();
		input.into(pixelSpeed);
		Vector inputX = new Vector(input.x, 0, 0);
		Vector inputY = new Vector(0, input.y, 0);

		float[][] M = cam.getInverseTransformationalMatrix();
		if (input.x != 0) {
			inputX = Matrix.vXm33(inputX, M);
			cam.w.plus(inputX);
			cam.w.normalize();
			cam.u = Vector.cross(cam.v, cam.w);
			cam.u.normalize();
		}
		if (input.y != 0) {
			inputY = Matrix.vXm33(input, M);
			cam.w.plus(inputY);
			cam.w.normalize();
			cam.v = Vector.cross(cam.w, cam.u);
			cam.v.normalize();
		}
	}

	background(bg);

	float[][] M = cam.getTransformationalMatrix();
	loadPixels();
	for(Voxel voxel: voxels) {
		voxel.draw(M);
	}
	updatePixels();

	//println(frameRate);
}

interface VoxelDrawer	{
	public void onVoxelDraw(Vector v);
}

VoxelDrawer voxelDraw = new VoxelDrawer()	{
	public void onVoxelDraw(Vector v)	{
		int x_cor = (int) (origin.x + 2*v.x);
		int y_cor = (int) (origin.y - 2*v.y);
		if (x_cor >= 0 && x_cor < width && y_cor >= 0 && y_cor < height) {
			pixels[y_cor*width + x_cor] = stroke;
		}
	}
};

void keyPressed()	{
	if (!autoRotate) {
		if (keyCode == UP) {
			isKeyOn[0] = true;
		}
		if (keyCode == RIGHT) {
			isKeyOn[1] = true;
		}
		if (keyCode == DOWN) {
			isKeyOn[2] = true;
		}
		if (keyCode == LEFT) {
			isKeyOn[3] = true;
		}

		if (key == '1') {
			cam.u.change(0, 0, -1);
			cam.v.change(0, 1, 0);
			cam.w.change(1, 0, 0);
			
		}else if (key == '2') {
			cam.u.change(1, 0, 0);
			cam.v.change(0, 1, 0);
			cam.w.change(0, 0, 1);
			
		}else if (key == '3') {
			cam.u.change(1, 0, 0);
			cam.v.change(0, 0, -1);
			cam.w.change(0, 1, 0);
		}
	}
}

void keyReleased()	{
	if (!autoRotate) {
		if (keyCode == UP) {
			isKeyOn[0] = false;
		}
		if (keyCode == RIGHT) {
			isKeyOn[1] = false;
		}
		if (keyCode == DOWN) {
			isKeyOn[2] = false;
		}
		if (keyCode == LEFT) {
			isKeyOn[3] = false;
		}
	}
}