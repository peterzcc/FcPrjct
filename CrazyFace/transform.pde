PVector transform(PVector local,PVector coordinate)
{
  PVector global;
  float theta=coordinate.z;
  float r=sqrt(coordinate.x*coordinate.x+coordinate.y*coordinate.y);
  float alpha=atan(coordinate.y/coordinate.x);
  PVector temp;
  temp.x=local.x+r*cos(alpha+theta);
  temp.y=local.y+r*sin(alpha+theta);
  global=PVector.add(temp,local);
  return global;
}
