using {managed} from '@sap/cds/common';

namespace avseb.devman;

type ObjectStatus : String enum {
  IN_ACTIVE;
  ACTIVE;
}

type SoftwareType : String enum {
  OS;
  APP;
}

type SoftwareStatus : String enum {
  INSTALLED;
  INSTALLATION_PENDING;
  ERROR;
}


/**
 * Device software can be installed on a device. There are 2 Types: OSS and APP. Each type can
 * be instaled once on a device.
 */
entity DeviceSoftware : managed {
  key ID           : String;
      name         : String;
      description  : String;
      softwareType : SoftwareType;
      objectStatus : ObjectStatus;
      url          : String; // The URL to the software package

}

/**
 * A device which is managed by the device management software
 */
entity Device : managed {
  key ID                  : String; // The world wide unique ID of the device
      deviceType          : String; // The type of device
      name                : String; // A free name of the device
      description         : String; // An additional description text
      objectStatus        : ObjectStatus; // ACTIVE or INACTIVE
      deviceStatus        : Composition of many DeviceStatus; // A collection of status values deliverered by the device
      deviceConfiguration : Composition of many DeviceConfiguration;
}

/**
 * A device can have multiple status values which are
 * identified by their status key.
 *
 * Examples:
 *
 * server.connectionState: OFFLINE 
 * deviceinfo.housing: DINRAIL
 * cbm.disc_data_free: 4907 
 * cbm.memory_free: 790376k
 */


entity DeviceStatus {
  key ID          : UUID;
      statusKey   : String;
      statusValue : String;

}

/**
 * A device can have multiple configuration values which are
 * identified by their configuration key. Configuration values
 * can be changed by the device management and be send to the
 * device.
 *
 * Examples:
 *
 * communication.online_interval: 60000
 * deviceinfo.timezone: Europe/Berlin
 */

entity DeviceConfiguration {
  key ID                 : UUID;
      device             : Association to Device;
      configurationKey   : String;
      configurationValue : String;

}

/**
 *  A device can have an operating system and a application.
 *  The software is assigned by the device manager and a installation request is
 *  send to the device. The device is loading the software from the URL and is installing it.
 *  The status of the installation process is send to the device manager.
 */
entity DeviceSoftwareAssignment {
  key ID       : UUID;
      device   : Association to Device;
      software : Association to DeviceSoftware;
      status   : SoftwareStatus;
}
