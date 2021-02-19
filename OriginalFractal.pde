class Branch {
  public int seed;
  public int gen;
  public float direction;
  public float origin_x;
  public float origin_y;
  public float branch_length;
};

float[] get_endpoint(Branch branch) {
  float x = (float)(branch.origin_x + branch.branch_length * Math.cos(branch.direction));
  float y = (float)(branch.origin_y + branch.branch_length * Math.sin(branch.direction));
  float[] out = { x, y };
  return out;
}

Branch[] advance_branch(Branch branch) {
  int seed1 = (branch.seed * 101 + 53) % 163;
  int seed2 = (branch.seed * 97 + 89) % 163;
  Branch branch1 = new Branch();
  Branch branch2 = new Branch();
  branch1.seed = seed1;
  branch2.seed = seed2;
  branch1.gen = branch.gen + 1;
  branch2.gen = branch.gen + 2;
  branch1.direction = branch.direction + (float)(((float)seed1 / 163 - 0.5) * Math.PI * (0.2 + pow(0.75, branch1.gen)));
  branch2.direction = branch.direction + (float)(((float)seed2 / 163 - 0.5) * Math.PI * (0.2 + pow(0.75, branch2.gen)));
  float[] branch_endpoint = get_endpoint(branch);
  branch1.origin_x = branch_endpoint[0];
  branch1.origin_y = branch_endpoint[1];
  branch2.origin_x = branch_endpoint[0];
  branch2.origin_y = branch_endpoint[1];
  branch1.branch_length = branch.branch_length * 0.75;
  branch2.branch_length = branch.branch_length * 0.75;
  
  Branch[] out = { branch1, branch2 };
  
  return out;
}

void draw_branch(Branch branch) {
  float[] endpoint = get_endpoint(branch);
  line(
    branch.origin_x,
    branch.origin_y,
    endpoint[0],
    endpoint[1]
  );
}

int tree_seed = 0;

Branch get_initial_branch() {
  Branch out = new Branch();
  out.seed = tree_seed;
  out.gen = 0;
  out.direction = (float)(3 * Math.PI / 2);
  out.origin_x = width / 2;
  out.origin_y = height;
  out.branch_length = 50;
  return out;
}

void setup() {
  size(300, 300);
  noLoop();
}

void draw() {
  background(color(0xc0, 0xc0, 0xc0));
  
  ArrayList<Branch> branches = new ArrayList<Branch>();
  branches.add(get_initial_branch());
  
  for (int i = 0; i < 15 /* number of iterations */; ++i) {
    ArrayList<Branch> new_branches = new ArrayList<Branch>();
    for (Branch branch : branches) {
      draw_branch(branch);
      Branch[] branch_pair = advance_branch(branch);
      new_branches.add(branch_pair[0]);
      new_branches.add(branch_pair[1]);
    }
    
    branches = new_branches;
  }
}

void mousePressed() {
  tree_seed = (int)(Math.random() * 163);
  redraw();
}
