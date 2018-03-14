//
//  ProfileRouter.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 07.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


class ProfileRouter {

    var presenter: ProfilePresenter?


    func presentDetail(with view: SUViewController, detail: SUViewController) {

        view.navigationController?.pushViewController(detail, animated: true)
    }

}
