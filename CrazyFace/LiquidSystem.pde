// Box2D Liquid System
// <http://www.shiffman.net/teaching/nature>
// Spring 2010

// A class to describe a group of Liquids
// An ArrayList is used to manage the list of Liquids 

class LiquidSystem  {

  ArrayList<Liquid> liquids;    // An ArrayList for all the liquids
  PVector origin;         // An origin point for where liquids are birthed

  LiquidSystem(int num, PVector v) {
    liquids = new ArrayList<Liquid>();             // Initialize the ArrayList
    origin = v.get();                        // Store the origin point

      for (int i = 0; i < num; i++) {
      liquids.add(new Liquid(origin.x,origin.y));    // Add "num" amount of liquids to the ArrayList
    }
  }

  void run() {
    // Display all the liquids
    for (Liquid p: liquids) {
      p.display();
    }

    // Liquids that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    for (int i = liquids.size()-1; i >= 0; i--) {
      Liquid p = liquids.get(i);
      if (p.done()) {
        liquids.remove(i);
      }
    }
  }

  void addLiquids(int n) {
    for (int i = 0; i < n; i++) {
      liquids.add(new Liquid(origin.x,origin.y));
    }
  }
  
  void addLiquids(int n,float x,float y) {
    for (int i = 0; i < n; i++) {
      liquids.add(new Liquid(x,y));
    }
  }
  // A method to test if the particle system still has liquids
  boolean dead() {
    if (liquids.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }

}
