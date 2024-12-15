import 'package:education_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;

  setUp(
    () async {
      cloudStoreClient = FakeFirebaseFirestore();
      final googleSignIn = MockGoogleSignIn();
      final signInAccount = await googleSignIn.signIn();
      final googleAuth = await signInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in
      final mockUser = MockUser(
        uid: 'someuid',
        email: 'bob@somedomain.com',
        displayName: 'Bob',
      );

      authClient = MockFirebaseAuth(mockUser: mockUser);
      final result = await authClient.signInWithCredential(credential);
      final user = result.user;
      dbClient = MockFirebaseStorage();

      dataSource = AuthRemoteDataSourceImpl(
        cloudStoreClient: cloudStoreClient,
        authClient: authClient,
        dbClient: dbClient,
      );
    },
  );

  const tPassword = 'Test password';
  const tEmail = 'Test email';
  const tFullName = 'Test fullName';


}
