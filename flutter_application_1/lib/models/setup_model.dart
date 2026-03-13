import 'package:flutter/material.dart';

// --- MÔ HÌNH PHÒNG, TẦNG, DỊCH VỤ (Giữ nguyên) ---
class RoomModel {
  String name;
  String area;
  String type;
  String note;
  String customPrice;
  bool isEditing;
  bool isUnderMaintenance;

  RoomModel({
    required this.name,
    this.area = '',
    this.type = 'Căn hộ 1 PN',
    this.note = '',
    this.customPrice = '',
    this.isEditing = false,
    this.isUnderMaintenance = false,
  });
}

class FloorModel {
  String name;
  List<RoomModel> rooms;
  bool isExpanded;
  FloorModel({
    required this.name,
    required this.rooms,
    this.isExpanded = true,
  });
}

class ServiceModel {
  String name;
  String price;
  String unit;
  IconData icon;
  ServiceModel({
    required this.name,
    required this.price,
    required this.unit,
    required this.icon,
  });
}

// --- KHO DỮ LIỆU CHUNG (SINGLETON PATTERN) ---
class SetupData {
  static final SetupData _instance =
      SetupData._internal();
  factory SetupData() => _instance;
  SetupData._internal();

  // Dữ liệu Thiết lập tòa nhà cơ bản
  String buildingName = 'Tòa nhà mặc định';
  String address = '';
  String owner = '';
  int aboveFloors = 0;
  int basementFloors = 0;
  String description = '';
  List<FloorModel> floors = [];
  String defaultPrice = '0';
  List<ServiceModel> services = [];
  String?
  ownerAvatarPath; // Đường dẫn ảnh đại diện (chụp từ điện thoại)
  String ownerAddress =
      '123 Đường ABC, Phường XYZ...'; // Địa chỉ cá nhân
  // --- DỮ LIỆU eKYC (XÁC THỰC DANH TÍNH) ---
  String idNumber = ''; // Số CCCD
  String dateOfBirth = ''; // Ngày sinh
  String gender = 'Nam'; // Giới tính
  String? frontIdPath; // Ảnh mặt trước CCCD
  String? backIdPath; // Ảnh mặt sau CCCD
  bool isEkycVerified =
      false; // Trạng thái đã xác minh hay chưa
  // --- DỮ LIỆU CƯ DÂN & VẬN HÀNH ---
  List<Map<String, dynamic>> residents = [];
  Map<String, UtilityRecord> utilityData = {};

  // ĐÃ DỌN SẠCH DỮ LIỆU THÔNG BÁO VÀ BẢO TRÌ GIẢ
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> maintenanceRequests =
      [];

  // --- KHO LƯU TRỮ HÓA ĐƠN (Mô phỏng Firebase) ---
  // --- KHO LƯU TRỮ HÓA ĐƠN (Dạng Map tương thích 100% với màn hình cũ) ---
  List<Map<String, dynamic>> invoices = [
    {
      'id': 'INV-10-01',
      'room': 'Tổng hợp thu',
      'month': 10,
      'year': 2023,
      'totalAmount': 385000000,
      'status': 'Đã thanh toán',
      'electricityCost': 45200000,
      'waterCost': 12800000,
      'otherCost': 5400000,
    },
    {
      'id': 'INV-10-02',
      'room': 'Tổng hợp nợ',
      'month': 10,
      'year': 2023,
      'totalAmount': 73200000,
      'status': 'Chưa thanh toán',
      'electricityCost': 0,
      'waterCost': 0,
      'otherCost': 0,
    },
    {
      'id': 'INV-09',
      'room': 'Tất cả',
      'month': 9,
      'year': 2023,
      'totalAmount': 420000000,
      'status': 'Đã thanh toán',
      'electricityCost': 0,
      'waterCost': 0,
      'otherCost': 0,
    },
    {
      'id': 'INV-08',
      'room': 'Tất cả',
      'month': 8,
      'year': 2023,
      'totalAmount': 395000000,
      'status': 'Đã thanh toán',
      'electricityCost': 0,
      'waterCost': 0,
      'otherCost': 0,
    },
    {
      'id': 'INV-07',
      'room': 'Tất cả',
      'month': 7,
      'year': 2023,
      'totalAmount': 350000000,
      'status': 'Đã thanh toán',
      'electricityCost': 0,
      'waterCost': 0,
      'otherCost': 0,
    },
    {
      'id': 'INV-06',
      'room': 'Tất cả',
      'month': 6,
      'year': 2023,
      'totalAmount': 310000000,
      'status': 'Đã thanh toán',
      'electricityCost': 0,
      'waterCost': 0,
      'otherCost': 0,
    },
    {
      'id': 'INV-05',
      'room': 'Tất cả',
      'month': 5,
      'year': 2023,
      'totalAmount': 280000000,
      'status': 'Đã thanh toán',
      'electricityCost': 0,
      'waterCost': 0,
      'otherCost': 0,
    },
  ];

  // --- THÔNG TIN TÒA NHÀ MỞ RỘNG (ĐÃ NÂNG CẤP) ---
  String? buildingCoverImgPath;
  String inaugurationDate = 'Chưa cập nhật';
  String totalArea = 'Chưa cập nhật';
  String buildingType = 'Chưa cập nhật';
  String hotline = '0912 345 678';
  String supportEmail = 'admin@phenikaa.com';
  String buildingDescription =
      'Chưa có mô tả chi tiết cho tòa nhà.';

  // Danh sách Tiện ích chung
  List<Map<String, dynamic>> buildingAmenities = [
    // Blue
    {
      'name': 'Camera 24/7',
      'icon': Icons.videocam,
      'color': 0xFF34A853,
    }, // Green
    {
      'name': 'Khóa vân tay',
      'icon': Icons.fingerprint,
      'color': 0xFFE67C73,
    }, // Orange
    {
      'name': 'Wifi miễn phí',
      'icon': Icons.wifi,
      'color': 0xFF8E24AA,
    }, // Purple
    {
      'name': 'Bãi xe',
      'icon': Icons.local_parking,
      'color': 0xFF78909C,
    }, // Grey
  ];

  // --- THUẬT TOÁN ĐẾM ĐỘNG ---
  int occupiedRooms = 0;
  int get residentCount => residents.length;
  int get totalRooms => floors.fold(
    0,
    (sum, floor) => sum + floor.rooms.length,
  );
  int get availableRooms => (totalRooms == 0)
      ? 0
      : totalRooms - occupiedRooms;
}

// --- MÔ HÌNH CHỈ SỐ ĐIỆN NƯỚC ---
class UtilityRecord {
  int oldElec;
  int newElec;
  int oldWater;
  int newWater;
  bool isRecorded;

  UtilityRecord({
    this.oldElec = 0,
    this.newElec = 0,
    this.oldWater = 0,
    this.newWater = 0,
    this.isRecorded = false,
  });

  int get consumedElec => (newElec - oldElec) > 0
      ? (newElec - oldElec)
      : 0;
  int get consumedWater =>
      (newWater - oldWater) > 0
      ? (newWater - oldWater)
      : 0;

  void rolloverToNextMonth() {
    oldElec = newElec;
    oldWater = newWater;
    newElec = 0;
    newWater = 0;
    isRecorded = false;
  }
}
