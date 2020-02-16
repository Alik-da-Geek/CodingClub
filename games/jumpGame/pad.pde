public class pad {
  private float x, y;
  private int id;
  public pad(float x1, float y1) {
    this.x=x1;
    this.y=y1;
    this.id=(int)(Math.random()*1000);
  }
  public float x() {
    return this.x;
  }
  public void x(float x1) {
    this.x=x1;
  }
  public float y(){
    return this.y;
  }
  public void y(float y1) {
    this.y=y1;
  }
  public void addY(float y1){
    this.y+=y1;
  }
  public int ID(){
    return this.id;
  }
  public void ID(int a){
    this.id=a;
  }
}
