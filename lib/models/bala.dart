class Bala {
        static Bala? _instance;
        // Avoid self instance
        Bala._();
        static Bala get instance{
            _instance??=  Bala._();
			return _instance!;
        }
}