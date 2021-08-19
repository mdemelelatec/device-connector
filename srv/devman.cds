using { avseb.devman as devman } from '../db/model';
service DevmanAPI  {
  entity Device as projection on devman.Device;
  entity DeviceSoftware as projection on devman.DeviceSoftware;
  entity DeviceSoftwareAssignment as projection on devman.DeviceSoftwareAssignment;
}

