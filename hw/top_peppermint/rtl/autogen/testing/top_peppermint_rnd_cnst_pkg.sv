// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/
//
// File is generated based on the following seed configuration:
//   hw/top_peppermint/data/top_peppermint_seed.testing.hjson


package top_peppermint_rnd_cnst_pkg;

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_handler_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'hE6BC3EF8
  };

  // Compile-time random permutation for LFSR output
  parameter alert_handler_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'hAB34758A_3DD8E938_14CF2493_6E073E53_B08B81BF
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetSramKey = {
    128'h5FC12BE3_C5333D77_AEE81229_AD96C8C5
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetSramNonce = {
    128'h96EDA91A_2485301A_48907C59_639294C3
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlRetLfsrSeed = {
    64'h3B5F713F_DEFA9C76
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetLfsrPerm = {
    128'hE6A5D33D_9F50F213_8C074BF8_35A6250D,
    256'h27301FF8_96EAC015_B85ED4FB_1DEB7D18_0AB75A1B_2369A31A_7CDD08BA_4425E932
  };

  ////////////////////////////////////////////
  // otp_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter otp_ctrl_top_specific_pkg::lfsr_seed_t RndCnstOtpCtrlLfsrSeed = {
    40'hE9_51AFC889
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_top_specific_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h7886_9D8DB026_40B30D9D_F3876524_4A0D4097_90684F16_50587208_93115589
  };

  // Compile-time random permutation for scrambling key/nonce register reset value
  parameter otp_ctrl_top_specific_pkg::scrmbl_key_init_t RndCnstOtpCtrlScrmblKeyInit = {
    256'h253DDFD7_8E689FD1_6D99B848_90C036F4_E8D7C83B_63ACDA01_9F8D7EDA_05D5A9DF
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey0 = {
    128'h98935387_D84D189E_94D201D4_CA6D258F
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey1 = {
    128'h957C6A0C_9C087E73_F96D33DE_76437066
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey2 = {
    128'hE6EFAA77_43364FAB_FDADBA18_67AEF4A5
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey3 = {
    128'h25D3438C_679BC5E1_E95B1124_9CA35DDE
  };

  // Compile-time digest const
  parameter otp_ctrl_top_specific_pkg::digest_const_t RndCnstOtpCtrlDigestConst0 = {
    128'h32067E17_86B83222_D00054B2_AF120FF8
  };

  // Compile-time digest const
  parameter otp_ctrl_top_specific_pkg::digest_const_t RndCnstOtpCtrlDigestConst1 = {
    128'h86A0B245_4CFA25B2_3B692148_E188C5CA
  };

  // Compile-time digest initial vector
  parameter otp_ctrl_top_specific_pkg::digest_iv_t RndCnstOtpCtrlDigestIV0 = {
    64'h49B7C7CD_1734B80E
  };

  // Compile-time digest initial vector
  parameter otp_ctrl_top_specific_pkg::digest_iv_t RndCnstOtpCtrlDigestIV1 = {
    64'h1AE014CE_FD7DE2CB
  };

  // OTP invalid partition default for buffered partitions
  parameter logic [39807:0] RndCnstOtpCtrlPartInvDefault = {
    704'({
      320'h3CEED93B3B6CC896B7B6E3922FFE2DA700D38096F86129EA6211F144189F2A7AB03EED49FFF8B260,
      384'hE1E06517F6A3B526B41BF4B85845C5FC37D49EA341A17D8A99C88F3FADD328B3CD2C735E8C3CA226C63A76344EE88E7F
    }),
    384'({
      64'h0,
      64'h8EE7450C8953BA06,
      256'h1690F4EEA0429A9907F6A0D9455E4CDB76014CA56A89D17D769B43DF26992CB6
    }),
    1024'({
      64'h0,
      64'hEA03F177B9D9B64C,
      256'h8D7E293E434D01C1B150D304D950FA2779A0F54DD2D67754AD8CDE1875A63C59,
      256'hB35295002D0EC43826651D1B33F50BDFA3F7D6E746DCE271E9C12D014656FC00,
      256'h812D48B252BEE0FD32847ED0AD3F2356797DA6E631F4218164D3643DE3D345A2,
      128'hC1759268D99AC019F24FA152C64C3DF1
    }),
    256'({
      64'h0,
      64'hACBA776A466893F0,
      128'h59FF4A5F90A02CB03F3C46E7BB4276EF
    }),
    384'({
      64'h0,
      64'h8BB12B9C7B0D6F09,
      128'h60E44C4AEE36D14D78041F7ED448B3B,
      128'h906F0ABAE550423FDD1E2420FECF440D
    }),
    128'({
      64'h863E92B607E0A428,
      16'h0, // unallocated space
      8'h69,
      8'h69,
      32'h0
    }),
    576'({
      64'h7A6CA0272FBB2A45,
      256'hC6E3D95995AB6DE517D4F7C755BB438EB2D154DC9C0C59350B4655D84237705A,
      256'hBB1EB796CA0C7967D4A6F20FC026FD6CEBE501567CF66A8296C3D69A4929C3BB
    }),
    8192'({
      8192'h0
    }),
    1088'({
      64'hEA8204499736FABB,
      1024'h0
    }),
    1088'({
      64'hCB6777E20BC19018,
      1024'h0
    }),
    1088'({
      64'h68B264030A7E3075,
      1024'h0
    }),
    1088'({
      64'h5766DFB11EF4A8A1,
      1024'h0
    }),
    1088'({
      64'h3B564D2B3302241F,
      1024'h0
    }),
    1088'({
      64'h91017B0ACAED5533,
      1024'h0
    }),
    1088'({
      64'h4E6B6D9EE5E84694,
      1024'h0
    }),
    1088'({
      64'h38030158241C385F,
      1024'h0
    }),
    11392'({
      64'hDB898548CA1A7F09,
      32'h0, // unallocated space
      6144'h0,
      1280'h0,
      1280'h0,
      1280'h0,
      32'h0,
      1280'h0
    }),
    256'({
      128'h0,
      128'h0
    }),
    4800'({
      64'h393B26042112CE2E,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      512'h0,
      128'h0,
      128'h0,
      224'h0,
      3360'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0
    }),
    2496'({
      64'h684212F41ED500B4,
      32'h0, // unallocated space
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      64'h0,
      32'h0,
      64'h0,
      32'h0,
      32'h0,
      256'h0,
      32'h0,
      992'h0
    }),
    512'({
      64'hC23B0F9C4778C5DE,
      448'h0
    })
  };

  ////////////////////////////////////////////
  // lc_ctrl
  ////////////////////////////////////////////
  // Diversification value used for all invalid life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivInvalid = {
    128'hBF0C3F86_70E567E3_D45248FC_C97C0789
  };

  // Diversification value used for the TEST_UNLOCKED* life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestUnlocked = {
    128'h01CC4386_3AA87FA6_80492A05_4B140BD9
  };

  // Diversification value used for the DEV life cycle state.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivDev = {
    128'hE143DFC4_B6DBEED1_BF90ABFB_15626596
  };

  // Diversification value used for the PROD/PROD_END life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    128'hD2EFD423_C911ABC2_4E671612_54169BDB
  };

  // Diversification value used for the RMA life cycle state.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivRma = {
    128'h5C2840F0_D87B7F93_3BE73A25_096F4A87
  };

  // Compile-time random bits used for invalid tokens in the token mux
  parameter lc_ctrl_pkg::lc_token_mux_t RndCnstLcCtrlInvalidTokens = {
    256'hDDC34EC6_5F281D26_D8CF913A_1D6EEFB2_7A1A456B_36C86F2E_9C630081_1CAF885F,
    256'hE8B32371_241D3A38_DF907746_9A0CAB69_AC24EEBA_B82AFE47_59CFC663_225C12D7,
    256'h753AA2EE_916025DF_0BE5C28F_4B20200E_6920CE35_374ACE64_E4CD2159_E36D6B67,
    256'h1C5A316A_042D0DFF_88A19559_E90E7C39_56634C78_DB0F9C86_6205C5DB_2FD08403
  };

  ////////////////////////////////////////////
  // aes
  ////////////////////////////////////////////
  // Default seed of the PRNG used for register clearing.
  parameter aes_pkg::clearing_lfsr_seed_t RndCnstAesClearingLfsrSeed = {
    64'h03E2045F_E16F058E
  };

  // Permutation applied to the LFSR of the PRNG used for clearing.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingLfsrPerm = {
    128'h895F66B3_A524A583_AD3194F4_050BA70F,
    256'hE17684F8_2F472ADE_7426BBCD_7F04E781_88FC91DF_DCB28D8C_0A12AB1D_56C1C6E5
  };

  // Permutation applied to the clearing PRNG output for clearing the second share of registers.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingSharePerm = {
    128'hF23C5C33_B6C284BF_AA154B40_1DD5B5C3,
    256'hFB1F979C_F8462428_A43904CA_EDFA7979_B420F48D_24A0599F_DAD8D866_A0BD5393
  };

  // Default seed of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_seed_t RndCnstAesMaskingLfsrSeed = {
    32'h3C86671D,
    256'h45561998_0F4674CA_14D88EBB_455250F4_E07680D8_246D7DE5_057EFC5B_212368D0
  };

  // Permutation applied to the output of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_perm_t RndCnstAesMaskingLfsrPerm = {
    256'h2E484109_4F5A349E_08352F33_968E6476_78603A49_666C7775_614D8F6E_15186B40,
    256'h47289D6F_21013055_3E700331_450D221A_136D4C59_1C575D17_252C949F_1F2B2A83,
    256'h7E394695_0597678B_040E3663_2980069A_37422362_6812110B_9091275C_853D071B,
    256'h567F8C0A_3B320C43_5E8D934E_65828A86_163C2D92_7A4B5102_54527984_88989B1D,
    256'h107C3800_81509920_3F0F725F_73447114_196A245B_4A877B74_9C89691E_5358267D
  };

  ////////////////////////////////////////////
  // kmac
  ////////////////////////////////////////////
  // Compile-time random data for PRNG default seed
  parameter kmac_pkg::lfsr_seed_t RndCnstKmacLfsrSeed = {
    32'h6C0DAF4E,
    256'h52301CD7_5EAAF2C4_EA2A3664_91A412AF_3E75B451_1771A607_249592FC_2952D333
  };

  // Compile-time random permutation for PRNG output
  parameter kmac_pkg::lfsr_perm_t RndCnstKmacLfsrPerm = {
    64'h991C59A4_2380599A,
    256'h891655A5_352D8298_5BE7D649_A35D936C_772D0495_6DD82092_6876E13E_C296CA3F,
    256'h14D97060_05346836_26374D4D_681B0195_6F0BB8A4_AB5105E9_58AEB0A2_51F239E7,
    256'hF6DCDD60_DB418AA3_0B55C628_37880887_4C4AB29F_04691867_490C0DA0_6BE945FE,
    256'h16B6A5C1_5B1FB708_15900027_E1C14537_4F262692_B16C5D63_B9B8116B_D6425DC7,
    256'h1CF00EC2_4B00E7D0_F014AAA6_C1EB68E4_091198B1_AB59BC27_1C712422_2D23B1AB,
    256'h9C54018E_6580B2A7_D699689A_0ECFEA5C_2137248B_31FC9DE1_758C2283_879492DB,
    256'h796602A4_0D57AC76_2CE97F60_33618765_9C2652AB_54A6C3C4_398220C4_05BC0828,
    256'h80F88A2E_E437A69B_9A85FC6D_28059E33_798FA2C6_6A004D50_8A53395A_534968F2,
    256'hCE5D12A9_2F0042AC_59C5EC31_9069D953_7452F80A_42A3AF54_702F30CA_8C5A6D87,
    256'h8078E2CB_51C6479E_30011CD2_66B229CE_599A469D_069160EF_9E6E6AA2_196D6EB4,
    256'h32B38F9B_A340A33A_E3998ED9_95287588_5C88B0D3_F53683DE_16782E4A_42A37C0C,
    256'h86317426_05C61204_9D3D3D4C_DA9236B2_2516987B_8556D402_FA4EED63_E6271C8D,
    256'h5B7A1A3D_2103DC61_9D51B1FB_19C52B43_6A298B86_53DA41BD_D778D419_3200871A,
    256'hC0A79D59_AE1F5F44_B15DC164_89E49570_04EBC4B6_3A6CD387_29A82FAE_07E46CBE,
    256'h4833A8D2_BF8D9049_782718D4_4CC5BC71_5436579E_99C091C4_32F048C9_D4382F6A,
    256'h9A4F69DE_6887114F_923A4432_AB9617AB_0BB4C6EA_863D174B_06940A2E_A8C7FD50,
    256'h5C581A62_CDBA9EF9_CD802C56_A700E230_0AF15549_2BA6595A_50BA4019_65324BA7,
    256'h87A24A06_A0A6111D_BD1CC1C1_F1532899_A2E5C0A8_4ABCA01A_E3161540_742A0564,
    256'h5AA56826_E45E2262_5464D32F_CF2AE2DD_B064D13A_F26187F2_DEBB304A_D99C6AB8,
    256'h8BD70E86_97C2522C_442AE0DA_FE14A593_03CC435D_96F1A29A_B521BB3D_7E802349,
    256'h6D1F42C4_12E55450_C339F105_33CA60B1_110D6A75_F1FA1313_19C2C3B9_22C65699,
    256'hADD9F668_E441DDCB_62132A88_7B562B8E_C74AC0CC_5E41D638_CA7882B8_CE9D3F2F,
    256'h89600982_67D43C0B_B7C17AD9_CB1404F0_EA4C2369_326C4663_0780C5BD_2869C9EE,
    256'hD27B56B1_B5395A1C_81206354_4915949D_7B9AE3FE_F36B5DB5_3CEC5770_CC1C422E,
    256'h104AA4F8_B8C0F23E_1240E5E1_00BCBF6A_C5C93AC1_7066A4AC_455F3248_7C6D8369,
    256'h147D4FCC_46ED3494_9AA939AC_6AC8C40A_EF89080C_2122C249_8B5D4E28_AA582D57,
    256'hBA121C40_1F748C79_B99B06C2_88AA112D_6722CCED_6871E620_264787A2_1AD05D55,
    256'hFAF86025_60704228_1D83876A_81BF30F1_1D554485_98BCD491_CE85CC1C_A4AB9519,
    256'h677930E5_983F45CF_A24DDF07_8155ED41_512FF521_6EA3D2B8_11E07E1A_21BD919F,
    256'h8B643A23_38DC71CE_C4C4ED14_CC11009D_D3846775_DDEBB5F6_5B2EC64C_5B7F9FB6,
    256'hFEC97DD4_50F1140F_497C74C9_30884528_3405226B_ECD77268_5A288573_A901D430
  };

  // Compile-time random data for PRNG buffer default seed
  parameter kmac_pkg::buffer_lfsr_seed_t RndCnstKmacBufferLfsrSeed = {
    32'hA8499700,
    256'h9610065E_87C3D7F6_261D9469_8B9D8EF1_F778309F_11160FBF_A7481BEE_6B55C518,
    256'h9F370C0A_37FBACC9_633925FD_92158D6D_E07BCCC8_9D3A03DC_B3705E6E_DFC6182F,
    256'h46339348_27F5C72A_5A1DF71B_12490281_35F95B3D_CEC35DDC_E040862D_3995FCBE
  };

  // Compile-time random permutation for LFSR Message output
  parameter kmac_pkg::msg_perm_t RndCnstKmacMsgPerm = {
    128'h81C5A3BE_5EF1992E_1DCC078D_330DADBA,
    256'h86A4E53F_6B521FC9_E9956AD4_B0C8197D_0FC9B12C_DCA9C21D_089139FF_81A5817C
  };

  ////////////////////////////////////////////
  // otbn
  ////////////////////////////////////////////
  // Default seed of the PRNG used for URND.
  parameter otbn_pkg::urnd_prng_seed_t RndCnstOtbnUrndPrngSeed = {
    32'hFA73A216,
    256'h740D626B_B001BE50_3766C584_10432FED_05072901_B78B2A4E_AFFBB536_6556C422
  };

  // Compile-time random permutation for URND permutation in BN MAC.
  parameter otbn_pkg::bn_mac_urnd_perm_t RndCnstOtbnBnMacUrndPerm = {
    256'h1902C337_9E844EAD_5EE34500_F47E10FE_DEE8C45F_F548AE78_AADCCB82_FB390FB5,
    256'hEE61CABB_91182844_BE47A57D_2CF9D84F_6C7C602E_C9177379_90EB0405_A408BC49,
    256'h8832D00A_465C1D50_F274FA42_B026153C_E2532BE1_F8A7560E_C11FCF21_92B10D70,
    256'hFCD3ACB4_36D7C69B_982D7522_2FD52996_852469A0_C813FFA2_343ECC23_2A80938C,
    256'h1A1164C7_3D4AA97F_F16B5A0C_8FDF33F3_14A1CDF0_83E60601_7BD95D9C_09865867,
    256'hF765CEBF_663B31A3_8D8B438A_AB893A71_6E38E407_E5524D9F_FD6881A6_628EECE7,
    256'h876F4B97_59C5B677_EFC04076_DDD6E9BA_7A274195_1C5BB73F_C216B2B9_BD259A55,
    256'hEA1EDA35_2051EDD4_72E06D12_0B94A854_AF1BB330_039DDB99_6AD14C57_F6B863D2
  };

  // Compile-time random reset value for IMem/DMem scrambling key.
  parameter otp_ctrl_pkg::otbn_key_t RndCnstOtbnOtbnKey = {
    128'hFDFC150C_6156628C_4AA2CEA5_DBA9F318
  };

  // Compile-time random reset value for IMem/DMem scrambling nonce.
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnOtbnNonce = {
    64'h0C483597_28441317
  };

  ////////////////////////////////////////////
  // keymgr_dpe
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrDpeLfsrSeed = {
    64'hC074F527_08CD3DCB
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrDpeLfsrPerm = {
    128'hA4DAE633_DD4B39BB_798C461E_DDD65405,
    256'h62A8F31E_ECAB8915_0859493D_34971F27_C8CEE446_D3F43A8A_78408300_DAF9CDAF
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrDpeRandPerm = {
    160'hEA7319E8_AF54906D_D700A08E_16C3CB73_077B73E4
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeRevisionSeed = {
    256'h67F1D201_23AE962A_003E30C2_A8942F27_C4CA21C6_327FB8E7_BF10C9EF_8B9C0DEB
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeSoftOutputSeed = {
    256'h2418423F_AFF41E7B_4FF4B0E6_9553D130_A0407693_DE540219_FC849445_3AE7FD82
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeHardOutputSeed = {
    256'hBA5F8D8F_F25C89C0_45CAFB05_418DFBE8_D7FCBBEF_ECD0724D_145309F4_4AAFF187
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeAesSeed = {
    256'h2FF7E109_3995149E_C3100940_1FD157BB_84A905B2_C5F9C732_916D3F0A_01064F24
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeKmacSeed = {
    256'h0EA0465A_16890A37_BB88177F_BC4C9D84_33B09B81_15D90B55_578192BA_15B877A0
  };

  // Compile-time random bits for generation seed when otbn destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeOtbnSeed = {
    256'h14FB372C_EF558975_129DEAE6_6BDCBEF8_597635D3_EFFEF7C2_50098FB9_64BE41D6
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeNoneSeed = {
    256'h92B97C16_69F1994B_9663DFCC_E042F0B3_50714F7A_42778626_D3A6AC18_2DB8D1A2
  };

  ////////////////////////////////////////////
  // csrng
  ////////////////////////////////////////////
  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivNonProduction = {
    128'h21875BFF_BD69423A_DCA64DA6_E21F0298,
    256'h923A2586_B01B2088_4604567B_C0249E2D_8AB794A7_633D9C6E_CF883C94_0F9C5210
  };

  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivProduction = {
    128'hB3C58633_8402BDF1_122BEB15_EA2FC002,
    256'hAAE3AA4C_DF001F7A_0161DD19_B6BE6C3F_A57AA970_C83CC6C9_148ECEE6_DBD6EA31
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'h69859159_AEBED647_ABB46389_F3C15DC7
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'h8313D02E_CA038E9E_13920507_091A5B7A
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlMainLfsrSeed = {
    64'h4275FFBB_34D2938D
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainLfsrPerm = {
    128'h69CDA6C8_74F8FA58_FC095777_03BA6AFE,
    256'h134A3CB1_5950CD0E_4480F9B2_75AE6048_2BC6FB5E_F5F6E425_2E908A80_70D57CC6
  };

  ////////////////////////////////////////////
  // rom_ctrl
  ////////////////////////////////////////////
  // Fixed nonce used for address / data scrambling
  parameter bit [63:0] RndCnstRomCtrlScrNonce = {
    64'h911D539B_E4585CD8
  };

  // Randomised constant used as a scrambling key for ROM data
  parameter bit [127:0] RndCnstRomCtrlScrKey = {
    128'h7FF2E1BA_5327BC85_1A8140FC_AEB768FD
  };

  ////////////////////////////////////////////
  // rv_core_ibex
  ////////////////////////////////////////////
  // Default seed of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_seed_t RndCnstRvCoreIbexLfsrSeed = {
    32'h780C7BBB
  };

  // Permutation applied to the LFSR of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_perm_t RndCnstRvCoreIbexLfsrPerm = {
    160'h2339D2B6_78809EA4_7BF51E4D_B0C80E3E_969A46D7
  };

  // Default icache scrambling key
  parameter logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] RndCnstRvCoreIbexIbexKeyDefault = {
    128'h78BC92EB_252479EC_E1502F2C_333B1543
  };

  // Default icache scrambling nonce
  parameter logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] RndCnstRvCoreIbexIbexNonceDefault = {
    64'h64FD06D4_CEB894C6
  };

endpackage : top_peppermint_rnd_cnst_pkg
