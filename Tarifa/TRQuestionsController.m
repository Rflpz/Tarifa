//
//  TRQuestionsController.m
//  Tarifa
//
//  Created by Rafael Lopez on 12/23/15.
//  Copyright © 2015 Rflpz. All rights reserved.
//

#import "TRQuestionsController.h"
#import <Social/Social.h>

@interface TRQuestionsController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *preguntas;
@end

@implementation TRQuestionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PREGUNTAS FRECUENTES";
    _tableView.separatorColor = [UIColor grayColor];

    UIImage *sideBarImage = [UIImage imageNamed:@"backButton.png"];
    sideBarImage = [self imageWithImage:sideBarImage scaledToSize:CGSizeMake(23,23)];
    
    
    UIBarButtonItem *sideBarButton = [[UIBarButtonItem alloc]
                                      initWithImage:sideBarImage
                                      style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(back)];
    sideBarButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = sideBarButton;
    _preguntas = [[NSMutableArray alloc]init];
    [_preguntas addObject:[self saveQuestion:@"¿Que nos motivo a generar esta app?" :@"Informativo" :@"El costo del servicio de taxis en Colima esta regulado mediante una serie de tarifas predefinidas, el problema viene cuando los taxistas no las respetan y en muchas ocaciones por un mismo servicio llegan a cobrar precios diferentes.\n\nPor tales motivos decidimos generar un app donde se puedan consultar de manera alternativa las tarifas dejando a un lado esa tabla gigante y generando transparencia en el servicio."]];
    [_preguntas addObject:[self saveQuestion:@"¿Cómo mover el pin?" :@"Básico" :@"Para poder mover el pin solo es necesario dejar presionado por unos segundos sobre el mapa y automaticamente pondra el pin sobre el lugar correspondiente.\n\nTambien puedes arrastrar el pin al lugar que tu desees."]];
    [_preguntas addObject:[self saveQuestion:@"¿Porqué no localiza mi posición?" :@"Básico" :@"Para poder hacer uso completo del app es necesario acceder a tu ubicación. Si negaste los permisos necesarios para obtenerla deberas acceder a configuración en el iPhone y otorgarlos."]];
    [_preguntas addObject:[self saveQuestion:@"¿Donde funciona el servicio de esta app?" :@"Básico" :@"El servicio que ofrece el app solo esta para la ciudad de Colima. \n\nSi tratas de usarla en otra ubicación no podras obtener los costos."]];
    [_preguntas addObject:[self saveQuestion:@"¿De donde se obtiene la información?" :@"Informativo" :@"Toda la informacion capturada para el funcionamiento del app es obtenido del mapa creado por el Gobierno del Estado de Colima.\n\nEsta NO es una app oficial del Gobierno del Estado de Colima sino de programadores externos."]];
}
-(NSMutableDictionary *)saveQuestion :(NSString *)titulo :(NSString *)subTitulo :(NSString *)respuesta{
    NSMutableDictionary *obj = [[NSMutableDictionary alloc]init];
    [obj setObject:titulo forKey:@"titulo"];
    [obj setObject:subTitulo forKey:@"subTitulo"];
    [obj setObject:respuesta forKey:@"respuesta"];
    return obj;
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (IBAction)goToFacebook:(id)sender {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/1192459877448478"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        TRWebController *webController = [[TRWebController alloc]initWithNibName:@"TRWebController" bundle:nil];
        webController.title = @"TARIFA FACEBOOK";
        webController.URLToSend = @"https://www.facebook.com/Tarifa-1192459877448478/";
        [self.navigationController pushViewController:webController animated:YES];  
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *obj = _preguntas[indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"titulo"];
    cell.detailTextLabel.text = [obj valueForKey:@"subTitulo"];;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:19.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"next.png"] scaledToSize:CGSizeMake(25,25)]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1.0f];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _preguntas.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    TRAnswerController *answerController = [[TRAnswerController alloc]initWithNibName:@"TRAnswerController" bundle:nil];
    NSDictionary *obj = _preguntas[indexPath.row];
    answerController.title = @"RESPUESTA";
    answerController.respuesta = [obj valueForKey:@"respuesta"];
    [self.navigationController pushViewController:answerController animated:YES];

}
- (IBAction)goToReport:(id)sender {
    TRReportController *reportController = [[TRReportController alloc]initWithNibName:@"TRReportController" bundle:nil];
    [self.navigationController pushViewController:reportController animated:YES];
}
- (IBAction)goToTableOnline:(id)sender {
    TRWebController *webController = [[TRWebController alloc]initWithNibName:@"TRWebController" bundle:nil];
    webController.title = @"TABLA DE PRECIOS ONLINE";
    webController.URLToSend = @"http://rflpz.com/tarifa.pdf";
    [self.navigationController pushViewController:webController animated:YES];
}
- (IBAction)shareOnFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *shareController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [shareController addURL:[NSURL URLWithString:@"http://on.fb.me/1Pqe68W"]];
        [shareController setCompletionHandler:^(SLComposeViewControllerResult result) {

            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:{
                    [self customAlert:@"Hey!" :@"Gracias por compartir nuestra App."];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:shareController animated:YES completion:nil];
    }
    else{
        [self customAlert:@"Opps :c" :@"Para compartir este evento ocupas hacer loggin en Facebook"];
    }
}
-(void)customAlert:(NSString *)info :(NSString *)title{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(title, nil);
    alertViewController.message = NSLocalizedString(info, nil);
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:alertViewController.buttonTitleFont.pointSize];
    //
    alertViewController.alertViewBackgroundColor = [UIColor whiteColor];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1.0f];
    alertViewController.messageColor = [UIColor blackColor];
    
    alertViewController.buttonColor = [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor blackColor];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end
